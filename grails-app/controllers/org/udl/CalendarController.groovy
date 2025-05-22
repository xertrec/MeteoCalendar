package org.udl
import java.time.LocalDate

class CalendarController {

    NagerDateService nagerDateService
    OpenMeteoService openMeteoService
    def springSecurityService

    def index() {
        def year = params.int('year') ?: new Date().year + 1900
        def month = params.int('month') ?: new Date().month + 1
        def country = params.country ?: 'ES'
        def city = country == 'AD' ? 'Andorra' : 'Barcelona'

        def holidays = nagerDateService.getHolidaysForCurrentMonth(country, year, month) ?: []
        def weatherByDate = openMeteoService.getWeatherForMonth(city, year, month)

        def calendar = Calendar.getInstance()
        calendar.set(year, month - 1, 1)
        def daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

        def weeks = []
        def currentWeek = []

        def user = springSecurityService.currentUser
        def startDate = LocalDate.of(year, month, 1)
        def endDate = LocalDate.of(year, month, daysInMonth)

        // 1. Eventos donde el usuario es propietario
        def ownerEvents = Event.findAllByUserAndDateBetween(user, startDate, endDate)

        // 2. Eventos donde el usuario es invitado (filtrado en memoria)
        def possibleGuestEvents = Event.findAllByDateBetween(startDate, endDate)
        def guestEvents = possibleGuestEvents.findAll { it.guests*.id.contains(user.id) }

        // 3. Unir y eliminar duplicados
        def events = (ownerEvents + guestEvents).unique()

        def eventsByDate = events.groupBy { it.date.toString() }

        (1..daysInMonth).each { day ->
            calendar.set(Calendar.DAY_OF_MONTH, day)
            def dayOfWeek = (calendar.get(Calendar.DAY_OF_WEEK) + 5) % 7 + 1
            if (day == 1) {
                (1..<dayOfWeek).each { currentWeek << null }
            }
            def dateStr = String.format('%04d-%02d-%02d', year, month, day)
            def weather = weatherByDate[dateStr]
            def dayEvents = eventsByDate[dateStr] ?: []
            currentWeek << [
                    day: day,
                    holiday: holidays.find { it.date == dateStr }?.localName ?: '',
                    weather: weather,
                    events: dayEvents
            ]
            if (dayOfWeek == 7 || day == daysInMonth) {
                while (currentWeek.size() < 7) {
                    currentWeek << null
                }
                weeks << currentWeek
                currentWeek = []
            }
        }

        render(view: 'index', model: [
                calendar: calendar,
                weeks: weeks,
                selectedYear: year,
                selectedMonth: month,
                selectedCountry: country,
                events: events
        ])
    }
}