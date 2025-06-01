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
        def viewType = params.view ?: 'month'
        def weekParam = params.int('week')

        def holidays = nagerDateService.getHolidaysForCurrentMonth(country, year, month) ?: []
        def weatherByDate = openMeteoService.getWeatherForMonth(city, year, month)

        def calendar = Calendar.getInstance()
        calendar.set(year, month - 1, 1)
        def daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

        def weeks = []
        def currentWeek = []

        def user = springSecurityService.currentUser
        if (!user) {
            flash.message = "Debes iniciar sesión para ver el calendario."
            redirect(controller: 'auth', action: 'auth')
            return
        }
        def startDate = java.time.LocalDate.of(year, month, 1)
        def endDate = java.time.LocalDate.of(year, month, daysInMonth)

        def ownerEvents = Event.findAllByUserAndDateBetween(user, startDate, endDate)
        def possibleGuestEvents = Event.findAllByDateBetween(startDate, endDate)
        def guestEvents = possibleGuestEvents.findAll { it.guests*.id.contains(user.id) }
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

        // Si la vista es semana, filtra la semana correspondiente
        int weekIndex = 0
        if (viewType == 'week') {
            if (weekParam != null) {
                if (weekParam == -1) {
                    weekIndex = weeks.size() - 1
                } else if (weekParam >= 0 && weekParam < weeks.size()) {
                    weekIndex = weekParam
                }
            } else {
                // Por defecto, semana actual si es el mes actual, si no la primera
                def today = new Date()
                if (year == today.year + 1900 && month == today.month + 1) {
                    def idx = weeks.findIndexOf { w -> w.any { d -> d?.day == today.date } }
                    if (idx >= 0) weekIndex = idx
                }
            }
            weeks = [weeks[weekIndex]]
        }

        render(view: 'index', model: [
                calendar: calendar,
                weeks: weeks,
                selectedYear: year,
                selectedMonth: month,
                selectedCountry: country,
                events: events,
                currentUser: user,
                viewType: viewType,
                weekIndex: weekIndex,
                totalWeeks: weeks.size(),
                contacts: user.contacts
        ])
    }
}