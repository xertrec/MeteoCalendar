package org.udl

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class AuthController {

    def springSecurityService
    def passwordEncoder = new BCryptPasswordEncoder()

    def create() {
        render(view: "create")
    }

    def save() {
        if (params.password != params.password2) {
            flash.message = "Las contraseñas no coinciden"
            render(view: "create", model: [user: [username: params.username]])
            return
        }

        def user = new User(
                username: params.username,
                password: passwordEncoder.encode(params.password),
                enabled: true
        )

        if (user.save(flush: true)) {
            def role = Role.findByAuthority('ROLE_USER') ?: new Role(authority: 'ROLE_USER').save(flush: true)
            user.authorities = [role] as Set
            user.save(flush: true)
            flash.message = "Usuario registrado correctamente"
            redirect(controller: "auth", action: "auth")
        } else {
            flash.message = "Error al registrar el usuario"
            render(view: "create", model: [user: user])
        }
    }

    def auth() {
        // Si el usuario ya está autenticado, redirige al calendario
        if (springSecurityService.isLoggedIn()) {
            redirect(controller: 'calendar', action: 'index')
            return
        }
        render(view: 'auth')
    }

    def login() {
        def user = springSecurityService.currentUser
        if (user) {
            log.info("Usuario autenticado: ${user.username}")
        } else {
            log.warn("Error de autenticación")
        }
    }
}