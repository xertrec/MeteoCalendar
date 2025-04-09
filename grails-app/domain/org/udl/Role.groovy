package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import org.bson.types.ObjectId

@GrailsCompileStatic
@EqualsAndHashCode(includes='authority')
@ToString(includes='authority', includeNames=true, includePackage=false)
class Role implements Serializable {

    private static final long serialVersionUID = 1
    ObjectId id
    String authority

    static constraints = {
        authority nullable: false, blank: false, unique: true
    }

    static mapping = {
    }

    String toString() {
        authority
    }
}
