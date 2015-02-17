SchemesView = require('./schemes-view.coffee')
$ = require('jquery')
AV = window.AV

class ExploreView

    constructor: ->
        Scheme = AV.Object.extend('Scheme')
        query = new AV.Query(Scheme)
        query.equalTo('score', 1)
        query.limit(100).find {
            success: (schemes) ->
                schemes = schemes.map (scheme) ->
                    JSON.parse scheme.attributes.colors
                new SchemesView(schemes)
                $('#image').hide()
        }

module.exports = ExploreView
