# UserView (Singleton)

$ = require('jquery')
AV = window.AV

class UserView

    constructor: ->
        if UserView.instance
            return UserView.instance
        UserView.instance = this
        @html()
        @bind AV

    html: ->
        user = AV.User.current()
        if user?
            html = "<li>" + user.attributes.username + "</li>"
            html += '<li id="logout">Logout</li>'
        else
            html = """<li id="login-button">Login</li><li id="signup-button">Signup</li>"""
        $('#user').html "<ul>" + html + "</ul>"

    bind: (AV) ->
        self = @
        $('#user').on 'click', '#login-button', -> $('#login').toggle()
        $('#user').on 'click', '#signup-button', -> $('#signup').toggle()

        $('#user').on 'click', '#logout', ->
            AV.User.logOut()
            self.html()

        $('#reset-password-button').click -> $('#password-reset').show()

        $('#password-reset .submit').click ->
            email=$('#password-reset .email').val()
            $this = $(this)
            handler =
                success: ->
                    $this.parent().hide()
                error: (error) ->
                    alert("Error: " + error.code + " " + error.message);
            AV.User.requestPasswordReset email, handler

        $('#signup .submit').click ->

            user = new AV.User()

            username = $('#signup .username').val()
            password = $('#signup .password').val()
            email=$('#signup .email').val()

            user.set("username", username);
            user.set("password", password);
            user.set("email", email);

            $this = $(this)

            handler =
                success: (user) ->
                    self.html()
                    $this.parent().hide()
                error: (user, error) ->
                    alert("Error: " + error.code + " " + error.message);
            user.signUp null, handler

        $('#login .submit').click ->

            user = new AV.User()

            username = $('#login .username').val()
            password = $('#login .password').val()

            $this = $(this)

            handler =
                success: (user) ->
                    self.html()
                    $this.parent().hide()
                error: (user, error) ->
                    alert("Error: " + error.code + " " + error.message);
            AV.User.logIn username, password, handler

module.exports = UserView
