fs = require 'fs'
converter = require("color-convert")();

data = fs.readFileSync 'data.json'
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

good = data.filter (elem) -> elem.score > 0
good = good.map (elem) -> parse(elem.colors)

beautify = (obj) ->
    str = JSON.stringify(obj)
    str = str.replace(new RegExp('\\[', 'g'), '\n')
    str = str.replace(new RegExp('[\\],]', 'g'), ' ')

console.log beautify(good)

