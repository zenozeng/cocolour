class User

    constructor: (AV, @$) ->
        @html()
        @bind AV, @$

    html: ->
        user = @get()
        if user?
            html = "<li>" + user.attributes.username + "</li>"
            html += '<li id="logout">Logout</li>'
        else
            html = """<li id="login-button">Login</li><li id="signup-button">Signup</li>"""
        @$('#user').html "<ul>" + html + "</ul>"

    get: -> AV.User.current()

    bind: (AV, $) ->
        self = @
        $('#login-button').click -> $('#login').toggle()
        $('#signup-button').click -> $('#signup').toggle()

        $('#logout').click ->
            AV.User.logOut()
            self.html()

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


module.exports = User
