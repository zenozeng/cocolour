colorsClustering = require "colors-clustering"
GenePool = require 'gene-pool'
fitness = require './fitness.coffee'
$ = require 'jquery'

SchemesView = require('./schemes-view.coffee')

schemesView = new SchemesView()

parseImage = (url) ->
    config =
        src: url
        minCount: 7

    displayColors = (clusters) ->
        html = clusters.map (cluster) ->
            color = cluster.color
            "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
        html = "<div class='colors'>#{html.join('')}</div>"
        $("#colors").html html

    colorsClustering config, (clusters) ->
        clusters.sort (a, b) -> b.weight - a.weight
        displayColors clusters
        opts =
            genes: clusters.map (color) -> color.color
            weights: clusters.map (color) -> color.weight
            K: 20
            N: 5
            mutationRate: 0.2
            birthRate: 1
            fitness: fitness
        colorSchemes = new GenePool(opts)
        colorSchemes.timeout 800, (err, schemes) ->
            console.error(err) if err
            $("#schemes").html schemesView.generate(schemes)
    $('#image').css {backgroundImage: "url(#{url})"}

class ImageView
    constructor: (url = './static/images/default.jpg') ->
        parseImage url

        # bind DND events
        body = document.body
        body.ondragover = (event) -> event.preventDefault()
        body.ondragend = (event) -> event.preventDefault()
        body.ondragenter = (event) -> event.preventDefault()
        body.ondragleave = (event) -> event.preventDefault()
        body.ondrag = (event) -> event.preventDefault()
        body.ondrop = (event) ->
            event.preventDefault()
            url = URL.createObjectURL(event.dataTransfer.files[0])
            parseImage url

module.exports = ImageView
