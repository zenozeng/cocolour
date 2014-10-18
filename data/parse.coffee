fs = require 'fs'
converter = require("color-convert")()
{print} = require './helper.coffee'

data = fs.readFileSync 'data.json'
data = JSON.parse data

console.log data

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

good = data.filter (elem) -> elem.score > 0
good = good.map (elem) -> parse(elem.colors)

bad = data.filter (elem) -> elem.score < 0
bad = bad.map (elem) -> parse(elem.colors)

console.log 'good', good.length
console.log 'bad', bad.length
