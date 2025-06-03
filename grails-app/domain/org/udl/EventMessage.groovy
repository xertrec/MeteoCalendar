package org.udl

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import grails.compiler.GrailsCompileStatic

@GrailsCompileStatic
class EventMessage {
    Event event
    User sender
    String content
    LocalDateTime sentAt = LocalDateTime.now()

    static belongsTo = [event: Event]

    static constraints = {
        event nullable: false
        sender nullable: false
        content blank: false
        sentAt nullable: false
    }

    static mapping = {
        event fetch: 'join'
        sender fetch: 'join'
    }

    String getFormattedTime() {
        return sentAt.format(DateTimeFormatter.ofPattern('HH:mm'))
    }
}