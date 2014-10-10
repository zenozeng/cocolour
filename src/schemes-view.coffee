class SchemesView

    constructor: (AV, $) ->
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

        $('body').on 'click', '.scheme .fa-heart-o', ->
            $scheme = $(this).parents('.scheme')
            if getScore($scheme) is 1
                setScore $scheme, 0
            else
                setScore $scheme, 1

        $('body').on 'click', '.scheme .fa-trash-o', ->
            $scheme = $(this).parents('.scheme')
            if getScore($scheme) is -1
                setScore $scheme, 0
            else
                setScore $scheme, -1
                $scheme.appendTo($('#schemes'));


module.exports = SchemesView
