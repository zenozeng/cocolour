class FavoriteView

    constructor: ->
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


module.exports = FavoriteView
