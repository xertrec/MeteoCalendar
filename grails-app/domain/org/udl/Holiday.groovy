package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import java.time.LocalDate

@GrailsCompileStatic
@EqualsAndHashCode(includes='name')
@ToString(includeNames=true)
class Holiday {

    String name
    String localName
    LocalDate date

    static constraints = {
        name nullable: false, blank: false
        localName nullable: false, blank: false
        date nullable: false
    }

    String toString() {
        name
    }
}
