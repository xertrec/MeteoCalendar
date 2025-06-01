package org.udl

class ContactController {
    def springSecurityService

    def index() {
        def currentUser = springSecurityService.currentUser
        if (!currentUser) {
            redirect(controller: 'auth', action: 'auth')
            return
        }

        [
                currentUser: currentUser,
                contacts: currentUser.contacts,
                messages: Message.findAllByReceiverOrSender(currentUser, currentUser,
                        [sort: 'sentAt', order: 'desc', max: 100])
        ]
    }

    def addContact() {
        def currentUser = springSecurityService.currentUser
        def contactEmail = params.email

        def contact = User.findByUsername(contactEmail)
        if (!contact) {
            flash.message = "Usuario no encontrado"
            redirect(action: 'index')
            return
        }

        if (!currentUser.contacts.contains(contact)) {
            currentUser.addToContacts(contact)
            currentUser.save(flush: true)
            flash.message = "Contacto añadido correctamente"
        } else {
            flash.message = "El usuario ya es un contacto"
        }

        redirect(action: 'index')
    }

    def chat() {
        def currentUser = springSecurityService.currentUser
        def contactId = params.id
        def contact = User.get(contactId)

        if (!contact || !currentUser.contacts.contains(contact)) {
            flash.message = "Contacto no encontrado"
            redirect(action: 'index')
            return
        }

        // Obtener mensajes entre los usuarios ordenados por fecha
        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }.sort { it.sentAt }

        render(template: 'chat', model: [
                contact: contact,
                messages: messages,
                currentUser: currentUser
        ])
    }

    def sendMessage() {
        def currentUser = springSecurityService.currentUser
        def contact = User.get(params.receiverId)

        if (!contact || !currentUser.contacts.contains(contact)) {
            render status: 404
            return
        }

        def message = new Message(
                sender: currentUser,
                receiver: contact,
                content: params.content,
                sentAt: LocalDateTime.now()
        )

        if (message.save()) {
            render template: 'message', model: [
                    message: message,
                    currentUser: currentUser
            ]
        } else {
            render status: 400
        }
    }
}