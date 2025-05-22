<%@ page contentType="text/html;charset=UTF-8" %>
<title>CALENDAR - Month</title>

<div style="display: flex; justify-content: space-between; align-items: center; margin: 20px 5% 0 5%;">
    <div>
        <g:link controller="event" action="create" class="btn btn-primary" style="margin-right: 10px;">
            <button type="button" style="padding:8px 16px;border:1px solid #ffb56b;border-radius:5px;font-size:14px;background-color:#ffb56b;color:#3d246c;cursor:pointer;transition:background-color 0.3s;">Nuevo Evento</button>
        </g:link>
    </div>
    <div style="display: flex; align-items: center;">
        <span style="margin-right: 15px; font-weight: bold; color: #3d246c;">
            <g:if test="${currentUser}">${currentUser.username}</g:if>
        </span>
        <form method="post" action="${request.contextPath}/logout" style="display:inline;">
            <button type="submit" class="btn btn-danger" style="padding:8px 16px;border:1px solid #a663cc;border-radius:5px;font-size:14px;background-color:#a663cc;color:#fff;cursor:pointer;transition:background-color 0.3s;">Log Out</button>
        </form>
    </div>
</div>

<form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="display: flex; justify-content: center; align-items: center; gap: 10px; margin: 20px 0;">
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

<h1 style="text-align:center;">Calendario del Mes</h1>
<div class="calendar-flex">
    <!-- Flecha izquierda -->
    <div class="arrow-block">
        <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
            <input type="hidden" name="year" value="${selectedMonth == 1 ? selectedYear - 1 : selectedYear}"/>
            <input type="hidden" name="month" value="${selectedMonth == 1 ? 12 : selectedMonth - 1}"/>
            <input type="hidden" name="country" value="${selectedCountry}"/>
            <button type="submit" class="arrow-btn">&#8592;</button>
        </form>
    </div>

    <div class="calendar-table-container">
        <table border="1" class="calendar-table">
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
                                <g:if test="${day.weather}">
                                    <div class="weather">
                                        <span style="font-size: 22px;">
                                            <g:if test="${day.weather.weatherCode != null}">
                                                ${org.udl.Weather.WEATHER_ICONS[day.weather.weatherCode as Integer] ?: '❔'}
                                            </g:if>
                                            <g:if test="${day.weather.temperature != null}">
                                                <span style="font-size: 13px;">${day.weather.temperature}°C</span>
                                            </g:if>
                                        </span>
                                    </div>
                                </g:if>
                                <div class="day-number">${day.day}</div>
                                <div class="holiday">${day.holiday ?: ''}</div>
                                <g:if test="${day.events}">
                                    <div class="event-list" style="position:absolute; bottom:30px; left:5px; color:#4a148c; font-size:13px; width:90%;">
                                        <div style="display: flex;">
                                            <div style="flex:1;">
                                                <g:each in="${day.events[0..<(day.events.size() > 2 ? 2 : day.events.size())]}" var="event">
                                                    <span class="event-title selectable-event"
                                                          data-event-id="${event.id}"
                                                          data-event-title="${event.title}"
                                                          data-event-date="${event.date}"
                                                          data-event-is-owner="${event.user.id == currentUser?.id ? 'true' : 'false'}"
                                                          style="cursor:pointer; user-select:text;">
                                                        📌 ${event.title}
                                                    </span><br/>
                                                </g:each>
                                            </div>
                                            <div style="flex:1;">
                                                <g:each in="${day.events.size() > 2 ? day.events[2..<(day.events.size() > 4 ? 4 : day.events.size())] : []}" var="event">
                                                    <span class="event-title selectable-event"
                                                          data-event-id="${event.id}"
                                                          data-event-title="${event.title}"
                                                          data-event-date="${event.date}"
                                                          data-event-is-owner="${event.user.id == currentUser?.id ? 'true' : 'false'}"
                                                          style="cursor:pointer; user-select:text;">
                                                        📌 ${event.title}
                                                    </span><br/>
                                                </g:each>
                                            </div>
                                        </div>
                                    </div>
                                </g:if>
                            </g:if>
                        </td>
                    </g:each>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <!-- Flecha derecha -->
    <div class="arrow-block">
        <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
            <input type="hidden" name="year" value="${selectedMonth == 12 ? selectedYear + 1 : selectedYear}"/>
            <input type="hidden" name="month" value="${selectedMonth == 12 ? 1 : selectedMonth + 1}"/>
            <input type="hidden" name="country" value="${selectedCountry}"/>
            <button type="submit" class="arrow-btn">&#8594;</button>
        </form>
    </div>
</div>

<!-- Modal para editar/eliminar/abandonar evento -->
<div id="eventModal" style="display:none; position:fixed; top:30%; left:50%; transform:translate(-50%,-30%); background:#fff6e0; border:2px solid #a663cc; border-radius:10px; padding:20px; z-index:1000;">
    <form id="editEventForm" method="post">
        <input type="hidden" name="id" id="modalEventId"/>
        <input type="hidden" id="modalEventIsOwner"/>
        <div id="editFields">
            <label for="modalEventTitle">Título:</label>
            <input type="text" name="title" id="modalEventTitle" required/><br>
            <label for="modalEventDate">Fecha:</label>
            <input type="date" name="date" id="modalEventDate" required/><br>
            <button type="submit">Guardar</button>
        </div>
        <div id="viewFields" style="display:none;">
            <label>Título:</label>
            <span id="modalEventTitleView"></span><br>
            <label>Fecha:</label>
            <span id="modalEventDateView"></span><br>
        </div>
        <button type="button" id="deleteEventBtn" style="background:#ffb56b;">Eliminar/Abandonar</button>
        <button type="button" onclick="closeModal()">Cancelar</button><br>
        <div id="inviteField">
            <label for="modalEventGuest">Invitar usuario (correo):</label>
            <input type="email" name="guestEmail" id="modalEventGuest" placeholder="usuario@correo.com"/><br>
        </div>
    </form>
</div>
<div id="modalOverlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.2); z-index:999;" onclick="closeModal()"></div>

<script>
    function closeModal() {
        document.getElementById('eventModal').style.display = 'none';
        document.getElementById('modalOverlay').style.display = 'none';
    }

    function openModal(eventData) {
        const isOwner = eventData.isOwner;
        document.getElementById('modalEventIsOwner').value = isOwner;
        if (isOwner) {
            document.getElementById('editFields').style.display = '';
            document.getElementById('inviteField').style.display = '';
            document.getElementById('viewFields').style.display = 'none';
            document.getElementById('modalEventTitle').value = eventData.title;
            document.getElementById('modalEventDate').value = eventData.date;
        } else {
            document.getElementById('editFields').style.display = 'none';
            document.getElementById('inviteField').style.display = 'none';
            document.getElementById('viewFields').style.display = '';
            document.getElementById('modalEventTitleView').textContent = eventData.title;
            document.getElementById('modalEventDateView').textContent = eventData.date;
        }
        document.getElementById('eventModal').style.display = 'block';
        document.getElementById('modalOverlay').style.display = 'block';
    }

    document.querySelectorAll('.selectable-event').forEach(span => {
        span.addEventListener('click', function(e) {
            e.stopPropagation();
            const eventId = this.dataset.eventId;
            const eventTitle = this.dataset.eventTitle;
            const eventDate = this.dataset.eventDate;
            const isOwner = this.dataset.eventIsOwner === "true";
            openModal({id: eventId, title: eventTitle, date: eventDate, isOwner: isOwner});

            const deleteBtn = document.getElementById('deleteEventBtn');
            if (isOwner) {
                deleteBtn.textContent = "Eliminar";
                deleteBtn.onclick = function() {
                    if (!confirm("¿Seguro que quieres eliminar este evento?")) return;
                    const id = document.getElementById('modalEventId').value;
                    fetch('${createLink(controller:"event", action:"delete")}', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'id=' + encodeURIComponent(id)
                    }).then(() => location.reload());
                };
            } else {
                deleteBtn.textContent = "Abandonar";
                deleteBtn.onclick = function() {
                    if (!confirm("¿Seguro que quieres abandonar este evento?")) return;
                    const id = document.getElementById('modalEventId').value;
                    fetch('${createLink(controller:"event", action:"leave")}', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'id=' + encodeURIComponent(id)
                    }).then(() => location.reload());
                };
            }
        });
    });

    document.getElementById('editEventForm').onsubmit = function(e) {
        e.preventDefault();
        const isOwner = document.getElementById('modalEventIsOwner').value === "true";
        if (!isOwner) return; // Solo el dueño puede editar
        const id = document.getElementById('modalEventId').value;
        const title = document.getElementById('modalEventTitle').value;
        const date = document.getElementById('modalEventDate').value;
        const guestEmail = document.getElementById('modalEventGuest').value;
        fetch('${createLink(controller:"event", action:"update")}', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + encodeURIComponent(id) +
                '&title=' + encodeURIComponent(title) +
                '&date=' + encodeURIComponent(date) +
                '&guestEmail=' + encodeURIComponent(guestEmail)
        }).then(() => location.reload());
    };
</script>

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

/* Flechas laterales */
.calendar-flex {
    display: flex;
    justify-content: center;
    align-items: stretch;
    width: 100%;
    height: 700px; /* altura fija para igualar flechas y tabla */
}

.arrow-block {
    background: #a663cc;
    height: 100%;
    min-width: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.arrow-btn {
    background: none;
    border: none;
    font-size: 48px;
    color: #fff;
    cursor: pointer;
    height: 100%;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}
.arrow-btn:hover {
    background: #8a4bb8;
}

.calendar-table-container {
    width: 80%;
    height: 100%;
    display: flex;
    align-items: stretch;
}

.calendar-table {
    width: 100%;
    height: 100%;
    border-collapse: collapse;
}

/* Tabla del calendario */
table {
    width: 100%;
    margin: 0 auto;
    border-collapse: collapse;
    background-color: #fff6e0;
    box-shadow: 0 4px 8px rgba(166, 99, 204, 0.08);
    border-radius: 10px;
    overflow: hidden;
    height: 100%;
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
.weather {
    position: absolute;
    top: 5px;
    left: 5px;
    font-size: 13px;
    color: #3d246c;
}

@media (max-width: 768px) {
    .calendar-flex {
        flex-direction: column;
        min-height: 700px;
    }
    .calendar-table-container {
        width: 100%;
    }
    table {
        height: 100%;
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
    .arrow-block {
        min-width: 100%;
        height: 60px;
    }
    .arrow-btn {
        font-size: 32px;
    }
}
</style>