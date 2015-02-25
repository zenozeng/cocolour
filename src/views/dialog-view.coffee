$ = require 'jquery'

class DialogView

    constructor: ($children) ->
        $view = $('#dialog')

        $children.on 'click', (e) -> e.stopPropagation()

        $view.html ''
        $view.append $children

        unless DialogView.bound
            @bind()
            DialogView.bound = true

        $view.fadeIn()

    bind: ->
        # ESC to exit
        $(document).on 'keydown', (e) =>
            @hide() if e.keyCode is 27

        $view = $('#dialog')
        $view.on 'click', => @hide()

    hide: ->
        $('#dialog').fadeOut()

module.exports = DialogView
