fs = require 'fs'
converter = require("color-convert")()
{print} = require './helper.coffee'
brain = require 'brain'
_ = require 'lodash'

data = fs.readFileSync '../data/training.json'
data = JSON.parse data

parse = (colors) ->

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
likes = likes.map (elem) -> parse(elem.colors)

dislikes = data.filter (elem) -> elem.score < 0
dislikes = dislikes.map (elem) -> parse(elem.colors)

console.log 'Likes', likes.length
console.log 'Dislikes', dislikes.length

# train
net = new brain.NeuralNetwork()

net.train likes.map (elem) -> {input: _.flatten(elem), output: {like: 1}}
net.train dislikes.map (elem) -> {input: _.flatten(elem), output: {dislike: 1}}

json = net.toJSON()
print json
