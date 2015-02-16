# Redirect old browsers
if !Array.prototype.map
    window.location.href = "http://browsehappy.com/"

# Initialize AVOS Cloud
AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj")

# Load views
ImageView = require('./views/image-view.coffee')
UserView = require('./views/user-view.coffee')
FavoriteView = require('./views/favorite-view.coffee')

$ = require('jquery')
$ ->
    # Initialize user view
    new UserView()

    # Display default view
    new ImageView()

    # Bind events
    $('#nav-favorite').click ->
        new FavoriteView()

