class UserView

    constructor: (AV, @$, schemesView) ->
        @html()
        @bind AV, @$, schemesView

    html: ->
        user = AV.User.current()
        if user?
            html = "<li>" + user.attributes.username + "</li>"
            html += '<li id="my-colors">My Colors</li>'
            html += '<li id="logout">Logout</li>'
        else
            html = """<li id="login-button">Login</li><li id="signup-button">Signup</li>"""
        @$('#user').html "<ul>" + html + "</ul>"

    bind: (AV, $, schemesView) ->
        self = @
        $('#user').on 'click', '#login-button', -> $('#login').toggle()
        $('#user').on 'click', '#signup-button', -> $('#signup').toggle()

        $('#user').on 'click', '#logout', ->
            AV.User.logOut()
            self.html()

        $('#reset-password-button').click -> $('#password-reset').show()

        $('#user').on 'click', '#my-colors', ->
            user = AV.User.current()
            if user
                username = user.attributes.username
                Scheme = AV.Object.extend("Scheme")
                query = new AV.Query(Scheme)
                query.equalTo("owner", username)
                query.equalTo("score", 1)
                query.find {
                    success: (schemes) ->
                        schemes = schemes.map (scheme) ->
                            JSON.parse scheme.attributes.colors
                        html = schemesView.generate schemes
                        $('#schemes').html html
                        $('#image').remove()
                        $('#colors').remove()
                        $('#main').css 'float', 'none'
                }

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
