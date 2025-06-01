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
        def contactToAdd = User.get(params.id)

        if (contactToAdd && !currentUser.contacts.contains(contactToAdd)) {
            currentUser.addToContacts(contactToAdd)
            currentUser.save(flush: true)
            flash.message = "Contacto añadido correctamente"
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

    def getMessages() {
        def currentUser = springSecurityService.currentUser
        def contact = User.get(params.contactId)

        if (!contact) {
            render([error: "Contacto no encontrado"] as JSON)
            return
        }

        def messages = Message.createCriteria().list {
            or {
                and {
                    eq('sender', currentUser)
                    eq('receiver', contact)
                }
                and {
                    eq('sender', contact)
                    eq('receiver', currentUser)
                }
            }
            order('sentAt', 'asc')
        }

        def formattedMessages = messages.collect { msg ->
            [
                    id: msg.id,
                    content: msg.content,
                    sentAt: msg.sentAt.format('HH:mm:ss'),
                    isFromCurrentUser: msg.sender.id == currentUser.id
            ]
        }

        render formattedMessages as JSON
    }

    def sendMessage() {
        def currentUser = springSecurityService.currentUser
        def receiver = User.get(params.receiverId)

        if (!receiver) {
            render(status: 400, text: 'Receptor no válido')
            return
        }

        def message = new Message(
                sender: currentUser,
                receiver: receiver,
                content: params.content?.trim()
        )

        if (message.save(flush: true)) {
            def messages = Message.findAll {
                (sender == currentUser && receiver == receiver) ||
                        (sender == receiver && receiver == currentUser)
            }.sort { it.sentAt }

            render(template: 'chat', model: [
                    messages: messages,
                    contact: receiver,
                    currentUser: currentUser
            ])
        } else {
            render(status: 500, text: 'Error al enviar mensaje')
        }
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