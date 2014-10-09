class User

    constructor: (AV, $) ->
        @user = null
        @bind AV, $

    get: -> @user

    bind: (AV, $) ->
        self = @
        $('#login-button').click -> $('#login').toggle()
        $('#signup-button').click -> $('#signup').toggle()
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
                    self.user = user
                    $('#user').html username
                    $this.parent().hide()
                error: (user, error) ->
                    # Show the error message somewhere and let the user try again.
                    alert("Error: " + error.code + " " + error.message);
            user.signUp null, handler

module.exports = User
