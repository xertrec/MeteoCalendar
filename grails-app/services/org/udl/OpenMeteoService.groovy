package org.udl

import groovy.json.JsonSlurper
import java.time.LocalDate

class OpenMeteoService {

    static final String API_BASE_URL = "https://api.open-meteo.com/v1/forecast"

    Map<String, Map> getWeatherForMonth(String city, int year, int month) {
        def latitude = getCityCoordinates()[city]?.lat
        def longitude = getCityCoordinates()[city]?.lon

        // Fecha de inicio: primer día del mes
        LocalDate startDate = LocalDate.of(year, month, 1)
        // Último día del mes
        int daysInMonth = java.time.YearMonth.of(year, month).lengthOfMonth()
        LocalDate lastDayOfMonth = LocalDate.of(year, month, daysInMonth)
        // Hoy + 14
        // días
        LocalDate maxEndDate = LocalDate.now().plusDays(14)
        // La fecha de fin es el menor entre el último día del mes y hoy+14
        LocalDate requestedEndDate = lastDayOfMonth.isBefore(maxEndDate) ? lastDayOfMonth : maxEndDate

        def apiUrl = "${API_BASE_URL}?latitude=${latitude}&longitude=${longitude}&start_date=${startDate}&end_date=${requestedEndDate}&daily=temperature_2m_max,weathercode&timezone=Europe/Madrid"

        try {
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