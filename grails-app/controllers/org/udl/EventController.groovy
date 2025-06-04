package org.udl

import grails.converters.JSON

import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter

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

            // Collect all guest emails from both single and multiple select
            def allGuestEmailsToUpdate = []

            // Add email from single guest dropdown if it's visible and selected
            if (params.guestEmail && params.guestEmail != "") { // Check for non-empty string
                allGuestEmailsToUpdate << params.guestEmail
            }

            // Add emails from multiple guests dropdown if it's visible and selected
            def multipleGuestEmails = params.list('multipleGuestEmails')
            if (multipleGuestEmails) {
                allGuestEmailsToUpdate.addAll(multipleGuestEmails)
            }

            // Ensure unique emails
            allGuestEmailsToUpdate = allGuestEmailsToUpdate.unique()

            def currentGuests = event.guests as Set // Convert to Set for easier comparison

            // Remove guests not in the new selection
            currentGuests.each { existingGuest ->
                if (!allGuestEmailsToUpdate.contains(existingGuest.username)) {
                    event.removeFromGuests(existingGuest)
                }
            }

            // Add new guests from the selection
            allGuestEmailsToUpdate.each { email ->
                def guestToAdd = User.findByUsername(email)
                if (guestToAdd && !currentGuests.contains(guestToAdd)) {
                    event.addToGuests(guestToAdd)
                }
            }

            if (event.save(flush: true, failOnError: true)) {
                flash.message = "Evento actualizado correctamente."
            } else {
                flash.message = "Error al actualizar el evento."
            }
        } else {
            flash.message = "No tienes permiso para editar este evento."
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
        if (event && event.guests.contains(user)) { // Use contains directly with User object
            event.removeFromGuests(user)
            event.save(flush: true)
        }
        redirect(controller: 'calendar', action: 'index')
    }

    def getGuests() {
        def event = Event.get(params.id)
        // Allow owner or guest to view the guest list
        if (event && (event.user == springSecurityService.currentUser || event.guests.contains(springSecurityService.currentUser))) {
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

        if (!event || (!event.user == currentUser && !event.guests.contains(currentUser))) {
            render(contentType: 'application/json') { [] }
            return
        }

        def messages = EventMessage.findAllByEvent(event, [sort: 'sentAt', order: 'asc'])
        def messageList = messages.collect { msg ->
            [
                    content: msg.content,
                    isSent: msg.sender.id == currentUser.id,
                    time: msg.sentAt.format(DateTimeFormatter.ofPattern('HH:mm')),
                    date: msg.sentAt.format(DateTimeFormatter.ofPattern('d MMMM')),
                    senderEmail: msg.sender.username  // Añadir el email del usuario que envía
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

        // Ensure the current user is either the event owner or a guest to send messages
        if (event.user != currentUser && !event.guests.contains(currentUser)) {
            render status: 403 // Forbidden
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