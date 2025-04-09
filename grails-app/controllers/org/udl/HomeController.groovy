package org.udl

class HomeController {
    def index() {
        def selectedMonth = params.int('month') ?: LocalDate.now().monthValue
        def selectedYear = params.int('year') ?: LocalDate.now().year
        def selectedCity = params.city ?: "Madrid"

        def calendar = calendarService.generateMonthMatrix(selectedYear, selectedMonth)
        def holidays = holidayService.getHolidaysForMonth(selectedYear, selectedMonth)
        def weather = weatherService.getWeatherForMonth(selectedYear, selectedMonth, selectedCity)

        render view: "calendar", model: [
                selectedMonth: selectedMonth,
                selectedYear : selectedYear,
                selectedCity : selectedCity,
                cities       : ["Barcelona", "Andorra"], // Puedes ampliarlo
                calendar     : calendar,
                holidays     : holidays,
                weather      : weather
        ]
    }
}
