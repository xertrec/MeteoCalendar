package org.udl

import groovy.json.JsonSlurper

class OpenMeteoService {

    static final String API_BASE_URL = "https://api.open-meteo.com/v1/forecast"

    Map<String, Map> getWeatherForMonth(String city, int year, int month) {
        def latitude = getCityCoordinates()[city]?.lat
        def longitude = getCityCoordinates()[city]?.lon

        def startDate = String.format('%04d-%02d-01', year, month)
        def endDate = String.format('%04d-%02d-%02d', year, month,
                Calendar.getInstance().with { set(year, month-1, 1); getActualMaximum(DAY_OF_MONTH) })

        def apiUrl = "${API_BASE_URL}?latitude=${latitude}&longitude=${longitude}&start_date=${startDate}&end_date=${endDate}&daily=temperature_2m_max,weathercode&timezone=Europe/Madrid"

        try {
            def url = new URL(apiUrl)
            def jsonResponse = new URL(apiUrl).getText('UTF-8')
            def slurper = new JsonSlurper()
            def result = slurper.parseText(jsonResponse)
            Map<String, Map> weatherByDate = [:]
            if (result?.daily?.time) {
                result.daily.time.eachWithIndex { date, idx ->
                    weatherByDate[date] = [
                            temperature: result.daily.temperature_2m_max[idx],
                            weatherCode: result.daily.weathercode[idx]
                    ]
                }
            }
            return weatherByDate
        } catch (Exception e) {
            println "Error fetching weather data: ${e.message}"
            return [:]
        }
    }

    static final Map cityCoordinates = [
            "Barcelona" : [lat: 41.38, lon: 2.17],
            "Andorra" : [lat: 42.5, lon: 1.5],
    ]
}