package org.udl

import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

@Transactional
class OpenMeteoService {

    static final String API_BASE_URL = "https://api.open-meteo.com/v1/forecast"

    Weather getWeatherByCity(String city) {
        def latitude = getCityCoordinates()[city]?.lat
        def longitude = getCityCoordinates()[city]?.lon

        def apiUrl = "${API_BASE_URL}&latitude=${latitude}&longitude=${longitude}&forecast_days=16&daily=temperature_2m_mean,weather_code"

        try {
            def url = new URL(apiUrl)
            def jsonResponse = url.getText('UTF-8')

            if (jsonResponse) {
                JsonSlurper slurper = new JsonSlurper()
                Object result = slurper.parseText(jsonResponse)

                if (result instanceof Weather) {
                    return (Weather) result
                } else {
                    return [:]
                }
            } else {
                return [:]
            }
        } catch (Exception e) {
            println "Error fetching weather data: ${e.message}"
            return [:]
        }
    }

    static final Map cityCoordinates = [
            "Barcelona" : [lat: 40.4168, lon: -3.7038],
            "Andorra" : [lat: 42.5, lon: 1.5],
    ]
}
