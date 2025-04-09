package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@GrailsCompileStatic
@EqualsAndHashCode
@ToString(includeNames=true)
class Weather {

    Integer weatherCode
    Double temperature // in Celsius

    static constraints = {
        weatherCode nullable: false
        temperature nullable: false
    }
}
