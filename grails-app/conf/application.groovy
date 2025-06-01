grails.plugin.springsecurity.logout.postOnly = false
grails.plugin.springsecurity.apf.storeLastUsername = true
grails.plugin.springsecurity.rejectIfNoRule = false
grails.plugin.springsecurity.fii.rejectPublicInvocations = false
// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'org.udl.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'org.udl.UserRole'
grails.plugin.springsecurity.authority.className = 'org.udl.Role'
grails.plugin.springsecurity.securityConfigType = "Annotation"

grails.plugin.springsecurity.controllerAnnotations.staticRules = [
        [pattern: '/',                      access: ['permitAll']],
        [pattern: '/error',                 access: ['permitAll']],
        [pattern: '/index',                 access: ['permitAll']],
        [pattern: '/index.gsp',             access: ['permitAll']],
        [pattern: '/shutdown',              access: ['permitAll']],
        [pattern: '/assets/**',             access: ['permitAll']],
        [pattern: '/**/js/**',             access: ['permitAll']],
        [pattern: '/**/css/**',            access: ['permitAll']],
        [pattern: '/**/images/**',         access: ['permitAll']],
        [pattern: '/**/favicon.ico',        access: ['permitAll']],
        [pattern: '/contact/sendMessage',   access: ['ROLE_USER']],
        [pattern: '/contact/**',            access: ['ROLE_USER']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
        [pattern: '/assets/**',      filters: 'none'],
        [pattern: '/**/js/**',       filters: 'none'],
        [pattern: '/**/css/**',      filters: 'none'],
        [pattern: '/**/images/**',   filters: 'none'],
        [pattern: '/**/favicon.ico', filters: 'none'],
        [pattern: '/**',             filters: 'JOINED_FILTERS']
]

grails.plugin.springsecurity.useSecurityEventListener = true

grails {
    mail {
        host = "smtp.gmail.com"
        port = 465
        username = "YOURMAIL@GMAIL.com"
        password = "YOURPASSWORD"
        props = ["mail.smtp.auth":"true",
                 "mail.smtp.socketFactory.port":"465",
                 "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
                 "mail.smtp.socketFactory.fallback":"false"]
    }
}

grails.plugin.springsecurity.failureHandler.exceptionMappings = [
        [exception: org.springframework.security.authentication.DisabledException.name,           url: '/user/accountDisabled'],
        [exception: org.springframework.security.authentication.CredentialsExpiredException.name, url: '/user/passwordExpired']
]

grails.plugin.springsecurity.auth.loginFormUrl = '/auth/auth'
grails.plugin.springsecurity.failureHandler.defaultFailureUrl = '/auth/auth?login_error=1'