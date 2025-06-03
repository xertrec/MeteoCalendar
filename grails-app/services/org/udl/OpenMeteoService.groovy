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
            "Barcelona"        : [lat: 41.38, lon: 2.17],
            "Andorra"          : [lat: 42.5, lon: 1.5],
            "Madrid"           : [lat: 40.4168, lon: -3.7038],
            "Paris"            : [lat: 48.8566, lon: 2.3522],
            "Berlin"           : [lat: 52.52, lon: 13.4050],
            "Roma"             : [lat: 41.9028, lon: 12.4964],
            "Lisboa"           : [lat: 38.7169, lon: -9.1399],
            "Londres"           : [lat: 51.5074, lon: -0.1278],
            "Ottawa"           : [lat: 45.4215, lon: -75.6972],
            "Washington D.C."  : [lat: 38.9072, lon: -77.0369],
            "Mexico City"      : [lat: 19.4326, lon: -99.1332],
            "Buenos Aires"     : [lat: -34.6037, lon: -58.3816],
            "Brasilia"         : [lat: -15.8267, lon: -47.9218],
            "Tokyo"            : [lat: 35.6895, lon: 139.6917],
            "Beijing"          : [lat: 39.9042, lon: 116.4074],
            "Moscow"           : [lat: 55.7558, lon: 37.6173],
            "Canberra"         : [lat: -35.2809, lon: 149.13],
            "Cairo"            : [lat: 30.0444, lon: 31.2357]
    ]

}



