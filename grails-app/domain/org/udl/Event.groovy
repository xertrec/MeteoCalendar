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

    static constraints = {
        title blank: false
        date nullable: false
        user nullable: false
    }
}