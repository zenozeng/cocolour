# Redirect old browsers
if !Array.prototype.map
    window.location.href = "http://browsehappy.com/"

# Initialize AVOS Cloud
AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj")

# Load views
UserView = require('./views/user-view.coffee')
ImageView = require('./views/image-view.coffee')
ExploreView = require('./views/explore-view.coffee')
FavoriteView = require('./views/favorite-view.coffee')

$ = require('jquery')
$ ->
    # Initialize user view
    new UserView()

    # Display default view
    new ImageView()

    # Bind events
    $('#nav > ul > li').click ->
        $('#nav > ul > li.current').removeClass 'current'
        $(this).addClass 'current'
    $('#nav-create').click -> new ImageView()
    $('#nav-explore').click -> new ExploreView()
    $('#nav-favorite').click -> new FavoriteView()
