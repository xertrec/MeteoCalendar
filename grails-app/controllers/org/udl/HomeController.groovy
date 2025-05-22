package org.udl

class HomeController {
    def index() {
        redirect(controller: 'auth', action: 'auth')
    }
}
