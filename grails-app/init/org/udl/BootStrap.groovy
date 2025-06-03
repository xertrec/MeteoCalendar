package org.udl

import grails.gorm.transactions.Transactional

class BootStrap {

    def springSecurityService

    def init = { servletContext ->
        addUsers()
    }
    def destroy = {
    }

    @Transactional
    void addUsers() {
        def adminRole = Role.findOrSaveWhere(authority: 'ROLE_ADMIN')
        def userRole = Role.findOrSaveWhere(authority: 'ROLE_USER')

        def adminUser = new User(username: 'a@a.a', password: '1234', authorities: [adminRole, userRole]).save()
    }
}