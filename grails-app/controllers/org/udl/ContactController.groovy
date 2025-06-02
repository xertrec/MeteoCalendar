package org.udl

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class ContactController {

    def springSecurityService

    def index() {
        def user = springSecurityService.currentUser
        [contacts: user?.contacts ?: [], currentUser: user]
    }

    def search() {
        def searchTerm = params.email
        def currentUser = springSecurityService.currentUser
        def results = []

        if (searchTerm && searchTerm != currentUser.username) {
            results = User.findAllByUsernameIlike("%${searchTerm}%").findAll { it.id != currentUser.id }
        }

        render(template: 'searchResults', model: [results: results])
    }

    def add() {
        def currentUser = springSecurityService.currentUser
        def email = params.email?.trim()

        if (!email) {
            flash.message = "Por favor, ingresa un correo electrónico"
            redirect(action: 'index')
            return
        }

        def contactToAdd = User.findByUsername(email)

        if (!contactToAdd) {
            flash.message = "No se encontró ningún usuario con ese correo"
            redirect(action: 'index')
            return
        }

        if (contactToAdd.id == currentUser.id) {
            flash.message = "No puedes agregarte a ti mismo como contacto"
            redirect(action: 'index')
            return
        }

        if (currentUser.contacts?.contains(contactToAdd)) {
            flash.message = "Este usuario ya está en tu lista de contactos"
            redirect(action: 'index')
            return
        }

        currentUser.addToContacts(contactToAdd)
        if (currentUser.save(flush: true)) {
            flash.message = "Contacto añadido correctamente"
        } else {
            flash.message = "Error al agregar el contacto"
        }

        redirect(action: 'index')
    }

    def remove() {
        def currentUser = springSecurityService.currentUser
        def contactToRemove = User.get(params.id)

        if (contactToRemove && currentUser.contacts.contains(contactToRemove)) {
            currentUser.removeFromContacts(contactToRemove)
            currentUser.save(flush: true)
            flash.message = "Contacto eliminado correctamente"
        }

        redirect(action: 'index')
    }

    @Secured(['ROLE_USER'])
    def sendMessage() {
        def currentUser = springSecurityService.currentUser
        def receiver = User.get(params.receiverId)

        if (!receiver) {
            render status: 404
            return
        }

        def message = new Message(
                sender: currentUser,
                receiver: receiver,
                content: params.content
        )

        if (message.save(flush: true)) {
            render status: 200
        } else {
            render status: 400
        }
    }

    def getMessages() {
        def currentUser = springSecurityService.currentUser
        def contact = User.get(params.contactId)

        if (!contact) {
            render status: 404
            return
        }

        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }.sort { it.sentAt }

        def messageList = messages.collect { msg ->
            [
                    content: msg.content,
                    isSent: msg.sender.id == currentUser.id,
                    time: msg.sentAt.format(java.time.format.DateTimeFormatter.ofPattern('HH:mm')),
                    date: msg.sentAt.format(java.time.format.DateTimeFormatter.ofPattern('d MMMM yyyy'))
            ]
        }

        render messageList as JSON
    }

    def chat(String id) {
        def contact = User.get(id)
        if (!contact) {
            render status: 404
            return
        }

        def currentUser = springSecurityService.currentUser
        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }

        if (params.ajax) {
            render template: "chat", model: [
                    contact: contact,
                    messages: messages
            ]
        } else {
            [contact: contact, messages: messages]
        }
    }
}