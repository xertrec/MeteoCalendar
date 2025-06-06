package org.udl

class ChatController {
    def springSecurityService

    def show(Long id) {
        def currentUser = springSecurityService.currentUser
        def contact = User.get(id)

        if (!contact || !currentUser.contacts.contains(contact)) {
            flash.message = "Contacto no encontrado o no autorizado"
            redirect(controller: 'contact', action: 'index')
            return
        }

        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }
        messages.sort { it.sentAt }

        // Agrupar mensajes por fecha
        def messagesByDate = messages.groupBy { it.sentAt.toLocalDate() }

        render(view: 'show', model: [
                contact: contact,
                currentUser: currentUser,
                messagesByDate: messagesByDate
        ])
    }

    def send() {
        def currentUser = springSecurityService.currentUser
        def receiver = User.get(params.receiverId)

        if (!receiver || !currentUser.contacts.contains(receiver)) {
            render(status: 400, text: 'Receptor no válido')
            return
        }

        def message = new Message(
                sender: currentUser,
                receiver: receiver,
                content: params.content
        )

        if (message.save(flush: true)) {
            render(status: 200, text: 'Mensaje enviado')
        } else {
            render(status: 500, text: 'Error al enviar mensaje')
        }
    }
}