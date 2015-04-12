converter = require('color-convert')()
_ = require 'lodash'
math = require 'mathjs'
convnet = require 'convnetjs'
brain = require 'brain'
Promise = require 'promise'
hypot = require './lib/hypot'

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

        ########################################################
        #
        # ANN (use [[H, S, L, ...], ])
        #
        ########################################################

        defaults =
            # iterations: 18
            iterations: 1000 # max iterations

        layers = [
            # input: 5 colors * 1 * [H, S, L]
            {type: 'input', out_sx: 16, out_sy: 1, out_depth: 1},

            # fully connected layers
            {type: 'fc', num_neurons: 16, activation: 'sigmoid'},

            # {type:'regression', num_neurons: 8},

            # In softmax, the outputs are probabilities that sum to 1
            {type: 'softmax', num_classes: 2}

            # simple binary SVM classifer
            # {type: 'svm', num_classes: 2}
        ]

        @net = new convnet.Net()
        @net.makeLayers layers

        @options = _.defaults options, defaults

        @trainer = new convnet.Trainer(@net, {
            # See also: http://imgur.com/a/Hqolp
            method: 'adadelta',
            # method: 'adagrad',

            learning_rate: 0.05,

            # You basically always want to use a non-zero l2_decay.
            # If it's too high, the network will be regularized very strongly.
            # This might be a good idea if you have very few training data.
            # If your training error is also very low (so your network is crushing the training set perfectly),
            # you may want to increase this a bit to have better generalization.
            # If your training error is very high (so the network is struggling to learn your data),
            # you may want to try to decrease it.
            l2_decay: 0.0005,

            # performs a weight update every 5 examples
            batch_size: 5
        })

    # Convert [[R, G, B], ] to target vector
    #
    # @param [Array] scheme array of RGB Array
    #
    preprocess: (colors) ->

        hslMatrix = colors.map (rgb) ->
            # convert rgb to hsl
            hsl = converter.rgb(rgb).hsl()

            # normalize hsl to [0, 1]
            hsl.map (elem, index) ->
                if index is 0
                    elem /= 360
                else
                    elem /= 100
                parseFloat elem.toFixed(3)

        vector = _.flatten(hslMatrix)

        distance = []
        for c1 in hslMatrix
            for c2 in hslMatrix
                unless c1 is c2
                    d = c1.map (elem, i) -> elem - c2[i]
                    distance.push hypot.apply(null, d)

        vector.push Math.min.apply(null, distance) # min distance
        # vector.push math.var(distance, 'biased') # var

        new convnet.Vol(vector)

    # Train data
    #
    # @param [Array] data cocolour style data [{rgbColors, score}]
    # @note this method can only be called once
    #
    train: (data) ->
        trainLabels = data.map (scheme) ->
            # 0 for positive and 1 for negative
            if scheme.score > 0 then 0 else 1

        trainData = data.map (scheme) => @preprocess scheme.colors

        getError = =>
            count = 0
            unmatchCount = 0
            trainData.forEach (data, i) =>
                isPositive = @rate(data, true) > 0
                isReallyPositive = trainLabels[i] is 0
                count++
                unmatchCount++ unless isPositive == isReallyPositive
            unmatchCount / count

        lastError = null
        for __ in [0..@options.iterations]
            trainData.forEach (data, i) =>
                @trainer.train data, trainLabels[i]
            error = getError()
            console.log process.pid, error
            if error < 0.32 # 最大拟合度
                break
            # if error is lastError
            #     # 已经收敛了，是时候退出循环了
            #     break
            lastError = error

        new Promise((resolve, reject) -> resolve())

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
    rate: (scheme, preprocessed = false) ->
        unless preprocessed
            input = @preprocess scheme.colors
        else
            input = scheme
        w = @net.forward(input).w
        positive = w[0]
        negative = w[1]

        positive - negative

    #
    # Save network as JSON
    #
    toJSON: ->
        @net.toJSON()

    # Load network from JSON
    #
    # @static
    # @param [Object] json JSON object
    #
    fromJSON: (json) ->
        ann = new ANN
        ann.net.fromJSON(json)
        ann

module.exports = ANN
