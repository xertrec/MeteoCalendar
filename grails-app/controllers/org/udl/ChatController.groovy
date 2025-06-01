package org.udl

class ChatController {
    def springSecurityService

    def chat(Long id) {
        def contact = User.get(id)
        def currentUser = springSecurityService.currentUser
        if (!contact || !currentUser.contacts.contains(contact)) {
            render(template: '/contact/chat', model: [messages: [], contact: contact, error: "No puedes chatear con este usuario.", currentUser: currentUser])
            return
        }
        def messages = Message.where {
            (sender == currentUser && receiver == contact) || (sender == contact && receiver == currentUser)
        }.list(sort: 'sentAt', order: 'asc')
        render(template: '/contact/chat', model: [messages: messages, contact: contact, currentUser: currentUser])
    }

    def sendMessage() {
        def user = springSecurityService.currentUser
        def contact = User.get(params.receiverId)
        if (!contact || !user.contacts.contains(contact)) {
            flash.message = "No puedes enviar mensajes a este usuario."
            redirect(controller: 'contact', action: 'index')
            return
        }
        def message = new Message(sender: user, receiver: contact, content: params.content)
        if (!message.save(flush: true)) {
            flash.message = "Error al enviar el mensaje."
        }
        def messages = Message.where {
            (sender == user && receiver == contact) || (sender == contact && receiver == user)
        }.list(sort: 'sentAt', order: 'asc')
        render(template: '/contact/chat', model: [contact: contact, messages: messages, currentUser: user])
    }
}