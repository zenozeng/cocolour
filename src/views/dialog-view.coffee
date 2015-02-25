$ = require 'jquery'

class DialogView

    constructor: ($children) ->
        $view = $('#dialog')
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
        $view.on 'click', (e) =>
            @hide() if e.target.id is 'dialog'

    hide: ->
        $('#dialog').fadeOut()

module.exports = DialogView
