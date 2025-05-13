<title>CALENDAR - Month</title>



<form method="get" action="${createLink(controller: 'calendar', action: 'index')}">
    <label for="year">Año:</label>
    <select id="year" name="year">
        <g:each in="${(new Date().year + 1900)..(new Date().year + 1904)}" var="year">
            <option value="${year}" ${year == selectedYear ? 'selected' : ''}>${year}</option>
        </g:each>
    </select>

    <label for="month">Mes:</label>
    <select id="month" name="month">
        <g:each in="${1..12}" var="month">
            <option value="${month}" ${month == selectedMonth ? 'selected' : ''}>${month}</option>
        </g:each>
    </select>

    <label for="country">País:</label>
    <select id="country" name="country">
        <option value="AD" ${selectedCountry == 'AD' ? 'selected' : ''}>Andorra</option>
        <option value="ES" ${selectedCountry == 'ES' ? 'selected' : ''}>España</option>
    </select>

    <button type="submit">Consultar</button>
</form>

<h1>Calendario del Mes</h1>
<table border="1">
    <thead>
    <tr>
        <th>Lunes</th>
        <th>Martes</th>
        <th>Miércoles</th>
        <th>Jueves</th>
        <th>Viernes</th>
        <th>Sábado</th>
        <th>Domingo</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${weeks}" var="week">
        <tr>
            <g:each in="${week}" var="day">
                <td class="${day?.day == new Date().date && selectedMonth == new Date().month + 1 && selectedYear == new Date().year + 1900 ? 'current-day' : ''} ${day?.holiday ? 'holiday-cell' : ''}">
                    <g:if test="${day}">
                        <div class="day-number">${day.day}</div>
                        <div class="holiday">${day.holiday ?: ''}</div>
                    </g:if>
                </td>
            </g:each>
        </tr>
    </g:each>
    </tbody>
</table>
<form method="post" action="${createLink(controller: 'home', action: 'index')}" style="text-align: center; margin-top: 20px;">
    <button type="submit" class="btn btn-danger">Log Out</button>
</form>

<style>
body {
    font-family: 'Arial', sans-serif;
    background-color: #f3e9ff;
    margin: 0;
    padding: 0;
    color: #3d246c;
}

h1 {
    text-align: center;
    color: #a663cc;
    margin-top: 20px;
    font-size: 24px;
}

p {
    text-align: center;
    font-size: 16px;
    color: #555;
}

form {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin: 20px 0;
}

form label {
    font-weight: bold;
    color: #3d246c;
}

form select, form button {
    padding: 8px 12px;
    border: 1px solid #ffb56b;
    border-radius: 5px;
    font-size: 14px;
}

form button {
    background-color: #ffb56b;
    color: #3d246c;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
}

form button:hover {
    background-color: #ff924c;
}

/* Tabla del calendario */
table {
    width: 80%;
    margin: 0 auto;
    border-collapse: collapse;
    background-color: #fff6e0;
    box-shadow: 0 4px 8px rgba(166, 99, 204, 0.08);
    border-radius: 10px;
    overflow: hidden;
}

th, td {
    width: 14.28%;
    height: 100px;
    text-align: left;
    vertical-align: top;
    border: 1px solid #e0c3fc;
    position: relative;
    padding: 10px;
}

th {
    height: 5px;
    background-color: #a663cc;
    color: white;
    font-weight: bold;
    text-align: center;
}

td {
    background-color: #f3e9ff;
    transition: background-color 0.3s;
}

td:hover {
    background-color: #e0c3fc;
}

td .day-number {
    position: absolute;
    top: 5px;
    right: 5px;
    font-size: 14px;
    font-weight: bold;
    color: #3d246c;
}

td .holiday {
    position: absolute;
    bottom: 5px;
    left: 5px;
    font-size: 16px;
    color: #ff924c;
    font-weight: bold;
}

.holiday-cell {
    background-color: #ffe0b2;
}

.current-day {
    background-color: #c3b1e1;
    border: 2px solid #a663cc;
}

@media (max-width: 768px) {
    table {
        width: 100%;
    }
    th, td {
        height: 80px;
        font-size: 12px;
    }
    td .day-number {
        font-size: 12px;
    }
    td .holiday {
        font-size: 14px;
    }
}
</style>