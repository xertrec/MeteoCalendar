package org.udl

import grails.validation.ValidationException
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

import static org.springframework.http.HttpStatus.NOT_FOUND

class AuthController {

    def springSecurityService
    def mailService

    def register(User user) {
        if (user == null) {
            notFound()
            return
        }

        if(params['password'] != params['password2']) {
            flash.message = "Passwords do not match!"
            respond user, view: 'create'
            return
        }

        if(User.findByUsername(user.username)) {
            flash.message = "Email already registered!"
            respond user, view: 'create'
            return
        }

        try {
            user.authorities = []
            user.authorities.add(Role.findByAuthority('ROLE_USER'))
            user.save(flush: true)
        } catch (ValidationException ignored) {
            respond user.errors, view:'create'
            return
        }

        mailService.sendMail {
            multipart true
            to user.username
            from "no-reply@test.dev"
            subject "[ROPLISP] Registered successfully!"
            html(view: '/email/newUser', model: [username: user.username])
        }

        flash.message = "User registered successfully!"
        redirect controller: "home", action: "index"
    }

    def forgotPassword() {
    }

    def passwordExpired() {
        [username: session['SPRING_SECURITY_LAST_USERNAME']]
    }

    def updatePassword() {
        def password = params?.password
        def password_new_1 = params?.password_new1
        def password_new_2 = params?.password_new2

        String username = session['SPRING_SECURITY_LAST_USERNAME']

        if (!username) {
            flash.message = 'Sorry, an error has occurred'
            redirect controller: 'login', action: 'auth'
            return
        }

        if (!password || !password_new_1 || !password_new_2 || password_new_1 != password_new_2 || password_new_1?.size() < 6 || password_new_1?.size() > 64) {
            flash.message = "La nueva contraseña no es correcta."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        User user = User.findByUsername(username)

        def passwordEncoder = new BCryptPasswordEncoder()
        if(!springSecurityService?.passwordEncoder?.matches(password, user.password)) {
            flash.message = "La contraseña actual no es correcta."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        if (password.equals(password_new_1)) {
            flash.message = "La nueva contraseña no puede ser igual a la contraseña anterior."
            render view: 'passwordExpired', model: [username: session['SPRING_SECURITY_LAST_USERNAME']]
            return
        }

        user.password = password_new_1
        user.passwordExpired = false
        user.save(failOnError: true) // if you have password constraints check them here

        sendMail {
            to username
            from "no.reply.act.atac@gmail.com"
            subject "[ACT-ATAC] Cambio de contraseña."
            html view: "/email/password_changed"
        }

        flash.message = "Contraseña actualizada correctamente."

        redirect controller: 'login', action: 'auth'
    }

    def passwordReset() {
        String username = params?.forgotUsername

        User user = User.findByUsername(username)

        if(user != null) {

            def generator = { String alphabet, int n ->
                new Random().with {
                    (1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
                }
            }

            def token = generator( (('A'..'Z')+('0'..'9')).join(), 15 )

            def uTok = username + "__" + token

            user.passwordResetToken = uTok
            user.save flush: true

            sendMail {
                to username
                from "no.reply.act.atac@gmail.com"
                subject "[SmokeFreeHomes] Reinicio de contraseña"
                html view: "/email/password_reset", model: [token: uTok]
            }
            flash.message = "Correo electrónico para restablecer la contraseña enviado correctamente."
        }
        else {
            flash.message = "No se pudo enviar el correo electrónico para restablecer la contraseña."
        }


        redirect controller: 'login', action: 'auth'
    }

    def newPassword() {
        def uTok = params?.uTok
        def username = uTok.split('__' as Closure)[0]

        render view: 'newPassword', model: [username: username, uTok: uTok]
    }

    def saveNewPassword() {
        String username = params?.uTok?.split("__" as Closure)[0]
        String token = params?.uTok
        String password1 = params?.password_new1
        String password2 = params?.password_new2

        User user = User.findByUsernameAndPasswordResetToken(username, token)

        if(user != null && password1 && password2 && password1 == password2) {
            user.password = password1
            user.passwordResetToken = null
            user.save()
            flash.message = "Contraseña actualizada correctamente."
        }

        redirect controller: 'login', action: 'auth'
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: ['User', params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
