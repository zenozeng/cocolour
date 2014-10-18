fs = require 'fs'
converter = require("color-convert")()
{print} = require './helper.coffee'

data = fs.readFileSync 'data.json'
data = JSON.parse data

data.sort (a, b) -> (new Date(a.createdAt)) - (new Date(b.createdAt))

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
likes = data.filter (elem, index) -> index < 150
likes = likes.map (elem) -> parse(elem.colors)

dislikes = data.filter (elem) -> elem.score < 0
dislikes = dislikes.filter (elem, index) -> index < 150
dislikes = dislikes.map (elem) -> parse(elem.colors)

console.log 'Likes', likes.length
console.log 'Dislikes', dislikes.length
