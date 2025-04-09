<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calendario</title>
    <style>
    body {
        font-family: sans-serif;
        padding: 20px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        width: 14.28%;
        height: 100px;
        border: 1px solid #ccc;
        vertical-align: top;
        padding: 5px;
    }
    th {
        background-color: #f2f2f2;
    }
    td span {
        font-weight: bold;
    }
    .holiday {
        color: red;
        font-size: 0.9em;
    }
    .weather {
        color: #555;
        font-size: 0.9em;
        margin-top: 5px;
    }
    </style>
</head>
<body>
<h1>Calendario</h1>

<!-- Formulario para seleccionar mes, año y ciudad -->
<g:form action="calendar" method="get">
    <label for="month">Mes:</label>
    <select id="month" name="month">
        <g:each in="${1..12}" var="i">
            <option value="${i}" ${i == selectedMonth ? 'selected' : ''}>${i}</option>
        </g:each>
    </select>

    <label for="year">Año:</label>
    <input type="number" id="year" name="year" value="${selectedYear}" required>

    <label for="city">Ciudad:</label>
    <select id="city" name="city">
        <g:each in="${cities}" var="c">
            <option value="${c}" ${c == selectedCity ? 'selected' : ''}>${c}</option>
        </g:each>
    </select>

    <button type="submit">Actualizar</button>
</g:form>

<!-- Tabla del calendario -->
<table>
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
    <g:each in="${calendar}" var="week">
        <tr>
            <g:each in="${week}" var="day">
                <td>
                    <g:if test="${day != null}">
                        <span>${day.dayOfMonth}</span>
                        <div class="holiday">
                            <g:each in="${holidays}" var="holiday">
                                <g:if test="${holiday.date == day}">
                                    ${holiday.name}
                                </g:if>
                            </g:each>
                        </div>
                        <div class="weather">
                            <g:each in="${weather}" var="dayWeather">
                                <g:if test="${dayWeather.date == day}">
                                    ${dayWeather.description} - ${dayWeather.temperature}°C
                                </g:if>
                            </g:each>
                        </div>
                    </g:if>
                </td>
            </g:each>
        </tr>
    </g:each>
    </tbody>
</table>
</body>
</html>
