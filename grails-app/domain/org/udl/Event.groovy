package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import java.time.LocalDate

@GrailsCompileStatic
@EqualsAndHashCode
@ToString(includeNames=true)
class Event {
    String title
    LocalDate date
    User user
    List<User> guests = []

    static hasMany = [guests: User]

    static mapping = {
        user fetch: 'join'  // Carga eager del usuario
        guests fetch: 'join' // Carga eager de los invitados
    }

    static constraints = {
        title blank: false
        date nullable: false
        user nullable: false
    }
}