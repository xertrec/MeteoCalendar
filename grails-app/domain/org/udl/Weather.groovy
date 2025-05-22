package org.udl

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@GrailsCompileStatic
@EqualsAndHashCode
@ToString(includeNames=true)
class Weather {

    Integer weatherCode
    Double temperature // in Celsius

    static constraints = {
        weatherCode nullable: false
        temperature nullable: false
    }

//    String weatherDescription = WEATHER_DESCRIPTIONS.getOrDefault(weatherCode, "Unknown code: ${weatherCode}")

    private static final Map<Integer, String> WEATHER_DESCRIPTIONS = [
            (0) : "Clear sky",
            (1) : "Mainly clear",
            (2) : "Partly cloudy",
            (3) : "Overcast",
            (45) : "Fog",
            (48) : "Depositing rime fog",
            (51) : "Drizzle: Light intensity",
            (53) : "Drizzle: Moderate intensity",
            (55) : "Drizzle: Dense intensity",
            (56) : "Freezing Drizzle: Light intensity",
            (57) : "Freezing Drizzle: Dense intensity",
            (61) : "Rain: Slight intensity",
            (63) : "Rain: Moderate intensity",
            (65) : "Rain: Heavy intensity",
            (66) : "Freezing Rain: Light intensity",
            (67) : "Freezing Rain: Heavy intensity",
            (71) : "Snow fall: Slight intensity",
            (73) : "Snow fall: Moderate intensity",
            (75) : "Snow fall: Heavy intensity",
            (77) : "Snow grains",
            (80) : "Rain showers: Slight",
            (81) : "Rain showers: Moderate",
            (82) : "Rain showers: Violent",
            (85) : "Snow showers: Slight",
            (86) : "Snow showers: Heavy",
            (95) : "Thunderstorm: Slight or moderate",
            (96) : "Thunderstorm with slight hail",
            (99) : "Thunderstorm with heavy hail"
    ].asImmutable()

    static final Map<Integer, String> WEATHER_ICONS = [
            (0): "☀️",    // Clear sky
            (1): "🌤️",   // Mainly clear
            (2): "⛅",    // Partly cloudy
            (3): "☁️",    // Overcast
            (45): "🌫️",  // Fog
            (48): "🌫️",  // Depositing rime fog
            (51): "🌦️",  // Drizzle: Light
            (53): "🌦️",  // Drizzle: Moderate
            (55): "🌦️",  // Drizzle: Dense
            (56): "🌧️",  // Freezing Drizzle: Light
            (57): "🌧️",  // Freezing Drizzle: Dense
            (61): "🌦️",  // Rain: Slight
            (63): "🌧️",  // Rain: Moderate
            (65): "🌧️",  // Rain: Heavy
            (66): "🌧️",  // Freezing Rain: Light
            (67): "🌧️",  // Freezing Rain: Heavy
            (71): "🌨️",  // Snow fall: Slight
            (73): "🌨️",  // Snow fall: Moderate
            (75): "❄️",   // Snow fall: Heavy
            (77): "❄️",   // Snow grains
            (80): "🌦️",  // Rain showers: Slight
            (81): "🌧️",  // Rain showers: Moderate
            (82): "⛈️",   // Rain showers: Violent
            (85): "🌨️",  // Snow showers: Slight
            (86): "❄️",   // Snow showers: Heavy
            (95): "⛈️",   // Thunderstorm: Slight or moderate
            (96): "⛈️",   // Thunderstorm with slight hail
            (99): "⛈️"    // Thunderstorm with heavy hail
    ].asImmutable()
}
