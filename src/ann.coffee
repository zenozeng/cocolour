converter = require('color-convert')()
_ = require 'lodash'
math = require 'mathjs'
convnet = require 'convnetjs'
brain = require 'brain'

# Simple wrapper of convnet for color schemes
#
# @example cons
#     ann = new ANN()
#     ann.train(cocolourData)
#     ann.run(scheme)
#
class ANN

    # Costructor
    #
    constructor: (options = {}) ->

        defaults =
            errorThresh: 0.2 # error threshold to reach
            iterations: 100 # max training iterations
            learningRate: 0.05

        @options = _.defaults options, defaults
        @net = new brain.NeuralNetwork()

    # Convert data to hsl vector
    #
    # @param [Array] data cocolour style data [{rgbColors, score}]
    #
    preprocess: (data) ->
        data.map (scheme) ->
            hslMatrix = scheme.colors.map (rgb) ->
                # convert rgb to hsl
                hsl = converter.rgb(rgb).hsl()

                # normalize hsl to [0, 1]
                hsl.map (elem, index) ->
                    if index is 0
                        elem /= 360
                    else
                        elem /= 100
                    parseFloat elem.toFixed(3)

            input = _.flatten(hslMatrix)

            {input: input, output: if scheme.score > 0 then {positive: 1} else {negative: 1}}

    # Train data
    #
    # @param [Array] data cocolour style data [{rgbColors, score}]
    # @note this method can only be called once
    #
    train: (data) ->
        @net.train @preprocess(data), @options
        @fn = @net.toFunction()


    # Verify data
    #
    # @param [Array] data cocolour style data [{rgbColors, score}]
    #
    verify: (data) ->
        getResults = (data) =>
            tests = data.map (scheme) =>
                rate = @rate scheme
                scheme.score * rate > 0 # 同号，表明判断相同
            passed = (tests.filter (elem) -> elem).length
            rate = passed / tests.length
            {total: tests.length, passed: passed, rate: rate}
        res =
            all: getResults(data)
            positive: getResults(data.filter (scheme) -> scheme.score > 0)
            negative: getResults(data.filter (scheme) -> scheme.score < 0)

    # Rate given scheme
    #
    # @param [Object] data cocolour style data {rgbColors, score}
    # @return [Float] [-1, 1] {1: like, 0: normal, -1: dislike}
    #
    rate: (scheme) ->
        [{input}] = @preprocess [scheme]
        res = @fn(input)
        positive = res.positive # 喜欢的置信度 (confidence) [0, 1]
        negative = res.negative # 讨厌的置信任度 [0, 1]
        if positive > negative then positive else -negative

module.exports = ANN
