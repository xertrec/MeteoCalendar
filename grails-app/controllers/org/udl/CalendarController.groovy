package org.udl

class CalendarController {

    NagerDateService nagerDateService

    def index() {
        def year = params.int('year') ?: new Date().year + 1900
        def month = params.int('month') ?: new Date().month + 1
        def country = params.country ?: 'ES'

        def holidays = nagerDateService.getHolidaysForCurrentMonth(country, year, month)
        if (holidays.isEmpty()) {
            holidays = []
        }

        def calendar = Calendar.getInstance()
        calendar.set(year, month - 1, 1)
        def daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

        def weeks = []
        def currentWeek = []
        (1..daysInMonth).each { day ->
            calendar.set(Calendar.DAY_OF_MONTH, day)
            def dayOfWeek = (calendar.get(Calendar.DAY_OF_WEEK) + 5) % 7 + 1
            if (day == 1) {
                (1..<dayOfWeek).each { currentWeek << null }
            }
            currentWeek << [
                    day: day,
                    holiday: holidays.find { it.date == String.format('%04d-%02d-%02d', year, month, day) }?.localName ?: ''
            ]
            if (dayOfWeek == 7 || day == daysInMonth) {
                while (currentWeek.size() < 7) {
                    currentWeek << null
                }
                weeks << currentWeek
                currentWeek = []
            }
        }

        render(view: 'index', model: [calendar: calendar, weeks: weeks, selectedYear: year, selectedMonth: month, selectedCountry: country])
    }
}