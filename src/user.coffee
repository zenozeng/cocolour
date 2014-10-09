class User

    constructor: (AV, $) ->
        user = @get()
        console.log user
        # console.log user
        $('#user').html user.attributes.username if user?
        @bind AV, $

    get: -> AV.User.current()

    bind: (AV, $) ->
        self = @
        $('#login-button').click -> $('#login').toggle()
        $('#signup-button').click -> $('#signup').toggle()

        $('#logout').click -> AV.User.logOut()

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
                    $('#user').html username
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
                    $('#user').html username
                    $this.parent().hide()
                error: (user, error) ->
                    alert("Error: " + error.code + " " + error.message);
            AV.User.logIn username, password, handler


module.exports = User
