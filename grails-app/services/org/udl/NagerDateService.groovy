package org.udl

import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

@Transactional
class NagerDateService {

    static final String API_BASE_URL = "https://date.nager.at/api/v3/PublicHolidays"

    Holiday getHolidaysByCountryAndYear(String countryCode, int year) {
        def apiUrl = "${API_BASE_URL}/PublicHolidays/${year}/${countryCode}"

        try {
            def url = new URL(apiUrl)
            def jsonResponse = url.getText('UTF-8')

            if (jsonResponse) {
                JsonSlurper slurper = new JsonSlurper()
                Object result = slurper.parseText(jsonResponse)

                if (result instanceof Holiday) {
                    return (Holiday) result
                } else {
                    return [:]
                }
            } else {
                return [:]
            }
        } catch (Exception e) {
            println "Error fetching holiday data: ${e.message}"
            return [:]
        }
    }

    static final Map countryCodes = [
            "Barcelona" : "ES",
            "Andorra" : "AD",
    ]
}
