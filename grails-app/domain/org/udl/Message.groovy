package org.udl

import java.time.LocalDateTime

class Message {
    User sender
    User receiver
    String content
    LocalDateTime sentAt = LocalDateTime.now()

    static constraints = {
        content blank: false
        sender nullable: false
        receiver nullable: false
        sentAt nullable: false
    }
    String getFormattedTime() {
        return sentAt.format(java.time.format.DateTimeFormatter.ofPattern('HH:mm'))
    }
}