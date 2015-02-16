if !Array.prototype.map
    window.location.href = "http://browsehappy.com/"

colorsClustering = require "colors-clustering"
GenePool = require "gene-pool"
fitness = require "./fitness.coffee"
$ = require "jquery"

# Data
AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj")

schemesView = new (require './schemes-view.coffee')(AV, $)
new (require './user-view.coffee')(AV, $, schemesView)

parseImage = (url) ->
    config =
        src: url
        minCount: 7

    displayColors = (clusters) ->
        html = clusters.map (cluster) ->
            color = cluster.color
            "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
        html = "<div class='colors'>#{html.join('')}</div>"
        document.getElementById("colors").innerHTML = html

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
    $ ->
        box = document.getElementById("image")
        box.style.backgroundImage = "url(#{url})"

parseImage './static/images/default.jpg'

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

$('#nav-favorite').click ->
    user = AV.User.current()
    if user
        username = user.attributes.username
        Scheme = AV.Object.extend("Scheme")
        query = new AV.Query(Scheme)
        query.equalTo("owner", username)
        query.equalTo("score", 1)
        query.limit(1000).find {
            success: (schemes) ->
                schemes = schemes.map (scheme) ->
                    JSON.parse scheme.attributes.colors
                html = schemesView.generate schemes
                $('#schemes').html html
                $('#image').hide()
        }

