package org.udl

class ContactController {
    def springSecurityService

    def index() {
        def user = springSecurityService.currentUser
        render(view: 'index', model: [contacts: user?.contacts])
    }

    def add() {
        def user = springSecurityService.currentUser
        def email = params.email
        def contact = User.findByUsername(email)
        if (!contact) {
            flash.message = "El usuario no existe."
        } else if (contact.id == user.id) {
            flash.message = "No puedes agregarte a ti mismo."
        } else if (user.contacts.contains(contact)) {
            flash.message = "Este contacto ya está en tu lista."
        } else {
            user.addToContacts(contact)
            user.save(flush: true)
            flash.message = "Contacto agregado."
        }
        redirect(action: 'index')
    }

    def remove() {
        def user = springSecurityService.currentUser
        def contact = User.get(params.id)
        if (user.contacts.contains(contact)) {
            user.removeFromContacts(contact)
            user.save(flush: true)
            flash.message = "Contacto eliminado."
        }
        redirect(action: 'index')
    }

    def chat(Long id) {
        def contact = User.get(id)
        def currentUser = springSecurityService.currentUser
        if (!contact || !currentUser.contacts.contains(contact)) {
            render(template: '/contact/chat', model: [messages: [], contact: contact, error: "No puedes chatear con este usuario.", currentUser: currentUser])
            return
        }
        def messages = Message.findAllBySenderAndReceiverOrReceiverAndSender(
                currentUser, contact, currentUser, contact, [sort: 'sentAt', order: 'asc']
        )
        if (params.ajax) {
            render(template: '/contact/chat', model: [messages: messages, contact: contact])
        } else {
            render(view: 'index', model: [contacts: currentUser.contacts])
        }
    }

    def sendMessage() {
        def user = springSecurityService.currentUser
        def contact = User.get(params.receiverId)
        if (!user.contacts.contains(contact)) {
            flash.message = "No puedes enviar mensajes a este usuario."
            redirect(action: 'index')
            return
        }
        new Message(sender: user, receiver: contact, content: params.content).save(flush: true)
        def messages = Message.where {
            (sender == user && receiver == contact) || (sender == contact && receiver == user)
        }.list(sort: 'sentAt', order: 'asc')
        if (params.ajax || request.xhr) {
            render(template: 'chat', model: [contact: contact, messages: messages, currentUser: user])
        } else {
            redirect(action: 'index')
        }
    }
}