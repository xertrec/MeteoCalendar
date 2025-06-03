package org.udl

import grails.converters.JSON

import java.time.LocalDate
class EventController {

    def springSecurityService

    def create() {
        render(view: 'create')
    }

    def save() {
        def user = springSecurityService.currentUser
        def eventDate = LocalDate.parse(params.date)
        def event = new Event(
                title: params.title,
                date: eventDate,
                user: user
        )
        if (event.save(flush: true)) {
            flash.message = "Evento creado"
        } else {
            flash.message = "Error al crear evento"
        }
        redirect(controller: 'calendar', action: 'index')
    }

    def update() {
        def event = Event.get(params.id)
        if (event && event.user == springSecurityService.currentUser) {
            event.title = params.title
            event.date = LocalDate.parse(params.date)
            if (params.guestEmail) {
                def guest = User.findByUsername(params.guestEmail)
                if (!guest) {
                    flash.message = "El usuario invitado no existe."
                    redirect(controller: 'calendar', action: 'index')
                    return
                }
                if (!event.guests*.id.contains(guest.id)) {
                    event.addToGuests(guest)
                }
            }
            event.save(flush: true, failOnError: true)
        }
        redirect(controller: 'calendar', action: 'index')
    }

    def delete() {
        def event = Event.get(params.id)
        if (event && event.user == springSecurityService.currentUser) {
            event.delete(flush: true)
        }
        redirect(controller: 'calendar', action: 'index')
    }

    def leave() {
        def event = Event.get(params.id)
        def user = springSecurityService.currentUser
        if (event && event.guests*.id.contains(user.id)) {
            event.removeFromGuests(user)
            event.save(flush: true)
        }
        redirect(controller: 'calendar', action: 'index')
    }

    def getGuests() {
        def event = Event.get(params.id)
        if (event && event.user == springSecurityService.currentUser) {
            render(contentType: 'application/json') {
                event.guests*.username
            }
        } else {
            render(contentType: 'application/json') { [] }
        }
    }

    def getEventMessages() {
        def event = Event.get(params.eventId)
        def currentUser = springSecurityService.currentUser

        if (!event || (!event.user == currentUser && !event.guests*.id.contains(currentUser.id))) {
            render(contentType: 'application/json') { [] }
            return
        }

        def messages = EventMessage.findAllByEvent(event, [sort: 'sentAt', order: 'asc'])
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

    def sendEventMessage() {
        def event = Event.get(params.eventId)
        def currentUser = springSecurityService.currentUser

        if (!event) {
            render status: 404
            return
        }

        def message = new EventMessage(
            event: event,
            sender: currentUser,
            content: params.content
        )

        if (message.save(flush: true)) {
            render status: 200
        } else {
            render status: 400
        }
    }
}