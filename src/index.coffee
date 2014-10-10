User = require './user.coffee'

if !Array.prototype.map
    window.location.href = "http://browsehappy.com/"

colorsClustering = require "colors-clustering"
GenePool = require "gene-pool"
fitness = require "./fitness.coffee"
$ = require "jquery"

display = (clusters) ->
    html = clusters.map (cluster) ->
        color = cluster.color
        "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
    html = "<div class='colors'>#{html.join('')}</div>"
    document.getElementById("colors").innerHTML = html

body = document.body
body.ondragover = (event) -> event.preventDefault()
body.ondragend = (event) -> event.preventDefault()
body.ondragenter = (event) -> event.preventDefault()
body.ondragleave = (event) -> event.preventDefault()
body.ondrag = (event) -> event.preventDefault()
body.ondrop = (event) ->
    event.preventDefault()
    box = document.getElementById("image")
    url = URL.createObjectURL(event.dataTransfer.files[0])
    config =
        src: url
        minCount: 7
    colorsClustering config, (clusters) ->
        clusters.sort (a, b) -> b.weight - a.weight
        display clusters
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
            html = schemes.map (colors) ->
                tmp = colors.map (color) -> "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
                "<div class='scheme' data-scheme='#{JSON.stringify(colors)}'>#{tmp.join('')}
                    <i class='fa fa-heart-o button'></i>
                    <i class='fa fa-trash-o button'></i></div>"
            $("#schemes").html html.join('')
    img = new Image
    img.onload = ->
        box.style.lineHeight = 0
        box.innerHTML = ""
        box.appendChild img
    img.src = url


# Data
AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj")
user = new User(AV, $)


# bind events
(->
    getScore = ($scheme) ->
        if $scheme.find('.fa-heart-o').hasClass 'selected'
            1
        else if $scheme.find('.fa-trash-o').hasClass 'selected'
            -1
        else
            0
    setScore = ($scheme, score) ->
        $scheme.find('.fa-heart-o').toggleClass('selected', score > 0)
        $scheme.find('.fa-trash-o').toggleClass('selected', score < 0)

        colors = $scheme.data('scheme')

        Scheme = AV.Object.extend("Scheme")
        scheme = new Scheme()

        scheme.set 'colors', colors
        scheme.set 'length', colors.length
        scheme.set 'score', score
        username = AV.User.current() && AV.User.current().attributes.username
        scheme.set 'creator', username
        ACL = new AV.ACL(AV.User.current())
        ACL.setPublicReadAccess(true)
        scheme.setACL(ACL)
        scheme.save()

    $('#schemes').on 'click', '.scheme .fa-heart-o', ->
        $scheme = $(this).parents('.scheme')
        if getScore($scheme) is 1
            setScore $scheme, 0
        else
            setScore $scheme, 1

    $('#schemes').on 'click', '.scheme .fa-trash-o', ->
        $scheme = $(this).parents('.scheme')
        if getScore($scheme) is -1
            setScore $scheme, 0
        else
            setScore $scheme, -1
            $scheme.appendTo($('#schemes'));
)()


