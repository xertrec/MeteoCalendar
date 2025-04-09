package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import org.bson.types.ObjectId

@GrailsCompileStatic
@EqualsAndHashCode
@ToString(includeNames=true)
class UserRole implements Serializable {

    private static final long serialVersionUID = 1
    ObjectId id
    User user
    Role role

    static constraints = {
        role unique: 'user'
    }

    static mapping = {
        user index: true
        role index: true
    }

    static UserRole create(User user, Role role, boolean flush = false) {
        if (!user || !role) {
            return null
        }

        def ur = new UserRole(user: user, role: role)
        if (!ur.save(flush: flush, failOnError: true)) {
            ur = null
        }
        ur
    }

    static boolean remove(User user, Role role, boolean flush = false) {
        if (!user || !role) {
            return false
        }

        return findByUserAndRole(user, role)?.delete(flush: flush)
    }
}
