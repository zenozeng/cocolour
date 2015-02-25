# UserView (Singleton)

$ = require('jquery')
AV = window.AV
DialogView = require('./dialog-view.coffee')

class UserView

    constructor: ->
        if UserView.instance
            return UserView.instance
        UserView.instance = this
        @updateNav()
        @bind AV

    updateNav: ->
        user = AV.User.current()
        if user?
            html = "<li>" + user.attributes.username + "</li>"
            html += '<li id="logout">Logout</li>'
            $('#nav-favorite').show()
        else
            html = """<li id="login-button">Login</li><li id="signup-button">Signup</li>"""
            $('#nav-favorite').hide()
        $('#user').html "<ul>" + html + "</ul>"

    displayLoginView: ->
        html = """
            <div id="login">
                <h2>Login</h2>
                <input type="text" placeholder="Username" class="username">
                <input type="password" placeholder="Password" class="password">
                <div class="submit">Login</div>
                <div id="reset-password-button">Forgot password?</div>
            </div>
        """

        $view = $(html)
        $view.find('#reset-password-button').click => @displayPasswordResetView()

        dialogView = new DialogView($view)

        $view.find('.submit').click =>

            user = new AV.User()

            username = $view.find('.username').val()
            password = $view.find('.password').val()

            $this = $(this)

            handler =
                success: (user) =>
                    @updateNav()
                    dialogView.hide()
                error: (user, error) ->
                    alert("Error: " + error.code + " " + error.message);
            AV.User.logIn username, password, handler

    displaySignupView: ->

        html = """
            <div id="signup">
                <h2>Sign Up</h2>
                <input type="text" placeholder="Username" class="username">
                <input type="password" placeholder="Password" class="password">
                <input type="email" placeholder="Email" class="email">
                <div class="submit">Submit</div>
            </div>
        """

        $view = $(html)

        dialogView = new DialogView($view)

        $view.find('.submit').click =>

            user = new AV.User()

            username = $view.find('.username').val()
            password = $view.find('.password').val()
            email = $view.find('.email').val()

            user.set("username", username);
            user.set("password", password);
            user.set("email", email);

            handler =
                success: (user) =>
                    @updateNav()
                    dialogView.hide()
                error: (user, error) ->
                    alert("Error: " + error.code + " " + error.message);
            user.signUp null, handler

    displayPasswordResetView: ->

        html = """
            <div id="password-reset">
                <h2>Reset Password</h2>
                <input type="email" placeholder="Email" class="email">
                <div class="submit">Reset</div>
            </div>
        """

        $view = $(html)

        dialogView = new DialogView($view)

        $view.find('.submit').click ->
            email=$('#password-reset .email').val()
            handler =
                success: ->
                    dialogView.hide()
                error: (error) ->
                    alert("Error: " + error.code + " " + error.message);
            AV.User.requestPasswordReset email, handler

    bind: (AV) ->
        $('#user').on 'click', '#login-button', => @displayLoginView()
        $('#user').on 'click', '#signup-button', => @displaySignupView()
        $('#user').on 'click', '#logout', ->
            AV.User.logOut()
            self.updateNav()

module.exports = UserView
