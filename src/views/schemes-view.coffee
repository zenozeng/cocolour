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

class SchemesView

    constructor: () ->

    generate: (schemes) ->
        schemes.map (colors) => @generateScheme(colors)

    # @return Array of jQuery Objects
    generateScheme: (colors) ->
        # sort colors
        colors.sort (a, b) ->
            a.some (elem, index) -> elem > b[index]

        colors = colors.map (color) -> "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
        html = "<div class='scheme' data-scheme='#{JSON.stringify(colors)}'>
            <div class='colors'>#{colors.join('')}</div>
            <i class='fa fa-heart-o button'></i>
            <i class='fa fa-trash-o button'></i></div>"
        # FIXME: 似乎这里解析出来的 jQuery 对象不对，好像变成一个 Array 了
        $scheme = $(html)
        $scheme.on 'click', '.fa-heart-o', ->
            if getScore($scheme) is 1 then setScore($scheme, 0) else setScore($scheme, 1)
        $scheme.on 'click', '.fa-trash-o', ->
            if getScore($scheme) is -1 then setScore($scheme, 0) else setScore($scheme, -1)
        $scheme[0]

module.exports = SchemesView
