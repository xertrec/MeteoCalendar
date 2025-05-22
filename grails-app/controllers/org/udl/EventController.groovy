package org.udl
import java.time.LocalDate
class EventController {

    def springSecurityService

    def create() {
        render(view: 'create')
    }

    def save() {
        def user = springSecurityService.currentUser
        def eventDate = LocalDate.parse(params.date)
        def existingEvents = Event.countByUserAndDate(user, eventDate)
        if (existingEvents >= 4) {
            flash.message = "Solo puedes tener hasta 6 eventos por día."
            redirect(controller: 'calendar', action: 'index')
            return
        }
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
}