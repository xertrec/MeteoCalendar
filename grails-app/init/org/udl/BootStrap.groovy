package org.udl

import grails.gorm.transactions.Transactional

class BootStrap {

    def init = { servletContext ->
        addUsers()
    }
    def destroy = {
    }

    @Transactional
    void addUsers() {
        def adminRole = Role.findOrSaveWhere(authority: 'ROLE_ADMIN')
        def userRole = Role.findOrSaveWhere(authority: 'ROLE_USER')

        def adminUser = new User(username: 'admin@roplisp.dev', password: 'changeme', authorities: [adminRole, userRole]).save()
        def defaultUser = new User(username: 'player@roplisp.dev', password: 'changeme', authorities: [userRole]).save()
    }
}