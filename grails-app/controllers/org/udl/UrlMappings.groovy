package org.udl

class UrlMappings {
    static mappings = {
        "/holidays"(resources: 'holidays')


        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

//        "/"(view:"/index")
        "/"(controller: "home", action: "index")
        "/contactos"(controller: "contact", action: "index")
        "/contact/sendMessage"(controller: 'contact', action: 'sendMessage') {
            method = ["GET", "POST"]
        }
        "500"(view:'/error')
        "404"(view:'/notFound')

    }
}
