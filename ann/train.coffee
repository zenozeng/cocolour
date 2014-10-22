fs = require 'fs'
converter = require("color-convert")()
{print} = require './helper.coffee'
brain = require 'brain'
_ = require 'lodash'

data = fs.readFileSync '../data/training.json'
data = JSON.parse data

normalize = (colors) ->

    colors.map (color) ->
        # convert rgb to hsl
        hsl = converter.rgb(color).hsl()

        # normalize hsl to [0, 1]
        hsl.map (elem, index) ->
            if index is 0
                elem /= 360
            else
                elem /= 100
            parseFloat elem.toFixed(3)

likes = data.filter (elem) -> elem.score > 0
likes = likes.map (elem) -> normalize(elem.colors)

dislikes = data.filter (elem) -> elem.score < 0
dislikes = dislikes.map (elem) -> normalize(elem.colors)

# train
net = new brain.NeuralNetwork()

opts =
    errorThresh: 0.005 # error threshold to reach
    iterations: 20000 # max training iterations
    log: true
    logPeriod: 10
    learningRate: 0.3

train = (hslMatrixArray, output) ->
    schemeVerctorArray = hslMatrixArray.map (hslMatrix) -> _.flatten hslMatrix
    data = schemeVerctorArray.map (vector) ->
        input: vector
        output: output
    net.train data, opts

verify = (hslMatrix, expectation) ->
    output = net.toFunction()(_.flatten(hslMatrix))
    console.log "Exp: ", expectation
    console.log "Output: ", output

train likes, {like: 1}
train dislikes, {dislike: 1}

verifyData = fs.readFileSync '../data/training.json'
verifyData = JSON.parse verifyData
getType = (score) ->
    if score > 0
        "like"
    else
        if score < 0
            "dislike"
        else
            "normal"
verifyData.forEach  (elem) ->
    verify normalize(elem.colors), getType(elem.score)
