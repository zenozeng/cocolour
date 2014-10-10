class SchemesView

    constructor: (AV, $) ->
        @bind AV, $

    generate: (colors) ->
        tmp = colors.map (color) -> "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
        "<div class='scheme' data-scheme='#{JSON.stringify(colors)}'>#{tmp.join('')}
            <i class='fa fa-heart-o button'></i>
            <i class='fa fa-trash-o button'></i></div>"


    bind: (AV, $) ->
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
