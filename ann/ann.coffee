converter = require("color-convert")()
brain = require 'brain'
_ = require 'lodash'

# Simple wrapper of brain for color schemes
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
            errorThresh: 0.005 # error threshold to reach
            iterations: 20000 # max training iterations
            log: true
            logPeriod: 10
            learningRate: 0.3

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

            hslVector = _.flatten(hslMatrix)

            {input: hslVector, output: {score: scheme.score}}

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
        tests = data.map (scheme) =>
            rate = @rate scheme
            match = scheme.score == rate
            console.log ""
            console.log "Rate: ", rate
            console.log "Expectation: ", scheme.score
            console.log "Match?: ", match
            match
        console.log ""
        console.log "Tests: ", tests.length
        console.log "Passed Tests: ", (tests.filter (elem) -> elem).length
        console.log "Rate(%): ", (tests.filter (elem) -> elem).length / tests.length

    # Rate given scheme
    #
    # @param [Object] data cocolour style data {rgbColors, score}
    # @return [Int] {1: like, 0: normal, -1: dislike}
    #
    rate: (scheme) ->
        [{input}] = @preprocess [scheme]
        {score} = @fn input
        if @options.log
            console.log "Scheme: ", scheme
            console.log "Score: ", score
        if score > 0.01
            1
        else
            if score < 0
                -1
            else
                0

module.exports = ANN