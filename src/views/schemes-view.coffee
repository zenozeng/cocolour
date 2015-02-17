AV = window.AV
$ = require('jquery')

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
    colors.sort (a, b) ->
        a.some (elem, index) -> elem > b[index]
    length = colors.length
    colors = JSON.stringify(colors)
    user = AV.User.current()

    if user
        username =  user.attributes.username

        Scheme = AV.Object.extend("Scheme")

        query = new AV.Query(Scheme)
        query.equalTo("colors", colors)
        query.equalTo("owner", username)
        query.find({
            success: (record) ->
                if record.length is 0
                    scheme = new Scheme()

                    scheme.set 'colors', colors
                    scheme.set 'length', length
                    scheme.set 'score', score

                    scheme.set 'owner', username
                    ACL = new AV.ACL(AV.User.current())
                    ACL.setPublicReadAccess(true)
                    scheme.setACL(ACL)
                    scheme.save()
                else
                    # already exits, update it
                    scheme = record[0]
                    scheme.set 'score', score
                    scheme.save()
        })

download = (filename, content) ->
    console.log filename, content
    content = 'data:text/plain;charset=utf-8,' + encodeURIComponent(content)
    $a = $("""<a href="#{content}" download="#{filename}"></a>""")
    a = $a[0]
    $('body').append($a)

    # note that $a.click() won't work
    # setTimeout is necessary because <a> needs to be clickable
    # see also: http://stackoverflow.com/questions/21403295/js-click-event-needs-settimeout-to-trigger-click-event
    setTimeout (->
        a.click()
        $a.remove()
    ), 0

class SchemesView

    constructor: (schemes) ->
        $container = $('#schemes')
        $container.html ''
        $container.append @generate(schemes)

    generate: (schemes) ->
        schemes.map (colors) => @generateScheme(colors)

    # @return Array of jQuery Objects
    generateScheme: (colors) ->
        # sort colors
        colors.sort (a, b) ->
            a.some (elem, index) -> elem > b[index]

        colorsHTML = colors.map (color) -> "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
        html = "<div class='scheme' data-scheme='#{JSON.stringify(colors)}'>
            <div class='colors'>#{colorsHTML.join('')}</div>
            <i class='fa fa-download button download-photoshop'>Photoshop</i>
            <i class='fa fa-download button download-gimp' title='Save it in ~/.gimp-2.8/palettes/ and restart GIMP.'>Gimp Palette</i>
            <i class='fa fa-heart-o button'></i>
            <i class='fa fa-trash-o button'></i></div>"
        $scheme = $(html)
        $scheme.on 'click', '.fa-heart-o', ->
            if getScore($scheme) is 1 then setScore($scheme, 0) else setScore($scheme, 1)
        $scheme.on 'click', '.fa-trash-o', ->
            if getScore($scheme) is -1 then setScore($scheme, 0) else setScore($scheme, -1)
        $scheme.on 'click', '.download-gimp', ->
            user = AV.User.current()
            username = if user then user.attributes.username + '@'else ''
            name = username + 'cocolour.com - ' + (new Date()).getTime()
            gen = require('../lib/gimp-palette.coffee')
            download name + '.gpl', gen(name, colors)
        $scheme[0]

module.exports = SchemesView
