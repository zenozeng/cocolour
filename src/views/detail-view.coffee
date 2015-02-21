$ = require 'jquery'
AV = window.AV
actPalette = require 'act-js'
gimpPalette = require '../lib/gimp-palette.coffee'

download = (filename, content) ->
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

generateFilename = ->
    user = AV.User.current()
    username = if user then user.attributes.username + '@'else ''
    name = username + 'cocolour.com - ' + (new Date()).getTime()

class DetailView

    constructor: (colors) ->
        @show(colors)

    show: (colors) ->
        html = """
            <div id="palette-detail-wrapper">
                <div id="palette-detail">
                    <h2>Download Palette</h2>
                    <div id="palette-detail-colors">
                    </div>
                    <i class='fa fa-download button download-act'>Adobe Color Table</i>
                    <br>
                    <i class='fa fa-download button download-gimp' title='Save it in ~/.gimp-2.8/palettes/ and restart GIMP.'>Gimp Palette</i>
                </div>
            </div>
        """

        unless $('#palette-detail-wrapper').length > 0
            $('body').append(html)

            $view = $('#palette-detail-wrapper')
            $view.hide()

            $view.find('.download-act').on 'click', ->
                name = generateFilename()
                actPalette colors, (err, content) ->
                    download name + '.act', content

            $view.find('.download-gimp').on 'click', ->
                name = generateFilename()
                content = gimpPalette(name, colors)
                content = 'data:text/plain;charset=utf-8,' + encodeURIComponent(content)
                download name + '.gpl', content

            $('#palette-detail').on 'click', (e) ->
                e.stopPropagation()

            $view.on 'click', =>
                @hide()

            $(document).on 'keydown', (e) =>
                @hide() if e.keyCode is 27

        $('#palette-detail-colors').html colors.map((color) ->
            rgb = color.join(', ')
            hex = '#' + (color.map (d) -> d.toString(16)).join('')
            """<div class="color">
                <div class="box" style="background: #{hex}"></div>
                #{hex} (#{rgb})</div>
            """
        ).join('')

        $('#palette-detail-wrapper').fadeIn()

    hide: ->
        $('#palette-detail-wrapper').fadeOut()

module.exports = DetailView
