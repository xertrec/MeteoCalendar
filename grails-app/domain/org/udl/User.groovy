package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import org.bson.types.ObjectId

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

    private static final long serialVersionUID = 1
    ObjectId id
    String username
    String password
    boolean enabled = true
    String passwordResetToken = null
    boolean accountExpired = false
    boolean accountLocked = false
    boolean passwordExpired = false

    // Relación de contactos
    Set<User> contacts = []
    static hasMany = [contacts: User]
    static mappedBy = [contacts: 'none']

    // Relación de roles
    Date lastLogin
    Integer loginCount = 0
    Set<Role> authorities
    static embedded = ['authorities']

    static constraints = {
        username nullable: false, blank: false, unique: true, email: true
        password nullable: false, blank: false, password: true
        passwordResetToken nullable: true
        lastLogin nullable: true
        loginCount nullable: true
    }

    static mapping = {
        password column: '`password`'
    }

    String toString() {
        username
    }
}
