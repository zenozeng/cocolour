fs = require 'fs'
converter = require("color-convert")();

data = fs.readFileSync 'data.json'
data = JSON.parse data

parse = (colors) ->
    colors.map (color) ->
        hsl = converter.rgb(color).hsl()
        color =
            h: hsl[0]
            s: hsl[1]
            l: hsl[2]

good = data.filter (elem) -> elem.score > 0
good = good.map (elem) -> parse(elem.colors)

console.log JSON.stringify(good, null, 4)
