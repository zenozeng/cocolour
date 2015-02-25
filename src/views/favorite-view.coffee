SchemesView = require('./schemes-view.coffee')
$ = require('jquery')
AV = window.AV

class FavoriteView

    constructor: ->
        user = AV.User.current()
        if user
            username = user.attributes.username
            Scheme = AV.Object.extend("Scheme")
            query = new AV.Query(Scheme)
            query.descending("updatedAt");
            query.equalTo("owner", username)
            query.equalTo("score", 1)
            query.limit(100).find {
                success: (schemes) ->
                    schemes = schemes.map (scheme) ->
                        JSON.parse scheme.attributes.colors
                    new SchemesView(schemes, score = 1)
                    $('#image').hide()
            }


module.exports = FavoriteView
