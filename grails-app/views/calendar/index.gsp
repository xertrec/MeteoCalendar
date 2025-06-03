<%@ page contentType="text/html;charset=UTF-8" %>
<title>CALENDAR - Month</title>

<!-- Topbar con botones y usuario -->
<div style="display: flex; justify-content: space-between; align-items: center; width: 80%; margin: 30px auto 0 auto; padding: 10px 0;">
    <div style="display: flex; gap: 10px;">
        <g:link controller="event" action="create" class="btn btn-primary">
            <button type="button" style="padding:8px 16px; border:1px solid #ffb56b; border-radius:5px; font-size:14px; background-color:#ffb56b; color:#3d246c; cursor:pointer;">Nuevo Evento</button>
        </g:link>
        <g:link controller="calendar" action="index" params="[view: 'month']" class="btn btn-secondary">
            <button type="button" style="padding:8px 16px; border:1px solid #a663cc; border-radius:5px; font-size:14px; background-color:#a663cc; color:#fff; cursor:pointer;">Ver mes</button>
        </g:link>
        <g:link controller="calendar" action="index" params="[view: 'week']" class="btn btn-secondary">
            <button type="button" style="padding:8px 16px; border:1px solid #a663cc; border-radius:5px; font-size:14px; background-color:#a663cc; color:#fff; cursor:pointer;">Ver semana</button>
        </g:link>
        <g:link controller="contact" action="index" class="btn btn-secondary">
            <button type="button" style="padding:8px 16px; border:1px solid #a663cc; border-radius:5px; font-size:14px; background-color:#a663cc; color:#fff; cursor:pointer;">Contactos</button>
        </g:link>
    </div>
    <div style="display: flex; align-items: center; gap: 15px;">
        <span style="font-weight: bold; color: #3d246c;">
            <g:if test="${currentUser}">${currentUser.username}</g:if>
        </span>
        <form method="post" action="${request.contextPath}/logout" style="display:inline;">
            <button type="submit" class="btn btn-danger" style="padding:8px 16px; border:1px solid #e53935; border-radius:5px; font-size:14px; background-color:#e53935; color:#fff; cursor:pointer;">Log Out</button>
        </form>
    </div>
</div>


<form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="display: flex; justify-content: center; align-items: center; gap: 10px; margin: 20px 0;">
    <label for="year">Año:</label>
    <select id="year" name="year">
        <g:each in="${(new Date().year + 1875)..(new Date().year + 1925)}" var="year">
            <option value="${year}" ${year == selectedYear ? 'selected' : ''}>${year}</option>
        </g:each>
    </select>

    <%
        def monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    %>

    <label for="month">Mes:</label>
    <select id="month" name="month">
        <g:each in="${1..12}" var="month">
            <option value="${month}" ${month == selectedMonth ? 'selected' : ''}>${monthNames[month - 1]}</option>
        </g:each>
    </select>

    <label for="country">País:</label>
    <select id="country" name="country">
        <option value="AD" ${selectedCountry == 'AD' ? 'selected' : ''}>Andorra</option>
        <option value="ES" ${selectedCountry == 'ES' ? 'selected' : ''}>España</option>
        <option value="FR" ${selectedCountry == 'FR' ? 'selected' : ''}>Francia</option>
        <option value="DE" ${selectedCountry == 'DE' ? 'selected' : ''}>Alemania</option>
        <option value="IT" ${selectedCountry == 'IT' ? 'selected' : ''}>Italia</option>
        <option value="PT" ${selectedCountry == 'PT' ? 'selected' : ''}>Portugal</option>
        <option value="GB" ${selectedCountry == 'GB' ? 'selected' : ''}>Reino Unido</option>
        <option value="CA" ${selectedCountry == 'CA' ? 'selected' : ''}>Canadá</option>
        <option value="US" ${selectedCountry == 'US' ? 'selected' : ''}>Estados Unidos</option>
        <option value="MX" ${selectedCountry == 'MX' ? 'selected' : ''}>México</option>
        <option value="AR" ${selectedCountry == 'AR' ? 'selected' : ''}>Argentina</option>
        <option value="BR" ${selectedCountry == 'BR' ? 'selected' : ''}>Brasil</option>
        <option value="JP" ${selectedCountry == 'JP' ? 'selected' : ''}>Japón</option>
        <option value="CN" ${selectedCountry == 'CN' ? 'selected' : ''}>China</option>
        <option value="RU" ${selectedCountry == 'RU' ? 'selected' : ''}>Rusia</option>
        <option value="AU" ${selectedCountry == 'AU' ? 'selected' : ''}>Australia</option>
        <option value="EG" ${selectedCountry == 'EG' ? 'selected' : ''}>Egipto</option>
    </select>


    <button type="submit">Consultar</button>
</form>

<h1 style="text-align:center;">Calendario del Mes</h1>

<div class="calendar-flex">
    <%-- Flecha izquierda --%>
    <div class="arrow-block">
        <g:if test="${viewType == 'week'}">
        <%-- Si estamos en la primera semana, al retroceder cambiamos de mes y week=última semana del mes anterior --%>
            <g:if test="${weekIndex == 0}">
                <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                    <input type="hidden" name="view" value="week"/>
                    <input type="hidden" name="country" value="${selectedCountry}"/>
                    <g:set var="prevMonth" value="${selectedMonth == 1 ? 12 : selectedMonth - 1}"/>
                    <g:set var="prevYear" value="${selectedMonth == 1 ? selectedYear - 1 : selectedYear}"/>
                    <input type="hidden" name="year" value="${prevYear}"/>
                    <input type="hidden" name="month" value="${prevMonth}"/>
                    <input type="hidden" name="week" value="-1"/><!-- El backend debe interpretar -1 como última semana -->
                    <button type="submit" class="arrow-btn">&#8592;</button>
                </form>
            </g:if>
            <g:else>
                <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                    <input type="hidden" name="year" value="${selectedYear}"/>
                    <input type="hidden" name="month" value="${selectedMonth}"/>
                    <input type="hidden" name="country" value="${selectedCountry}"/>
                    <input type="hidden" name="view" value="week"/>
                    <input type="hidden" name="week" value="${weekIndex - 1}"/>
                    <button type="submit" class="arrow-btn">&#8592;</button>
                </form>
            </g:else>
        </g:if>
        <g:else>
            <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                <input type="hidden" name="year" value="${selectedMonth == 1 ? selectedYear - 1 : selectedYear}"/>
                <input type="hidden" name="month" value="${selectedMonth == 1 ? 12 : selectedMonth - 1}"/>
                <input type="hidden" name="country" value="${selectedCountry}"/>
                <button type="submit" class="arrow-btn">&#8592;</button>
            </form>
        </g:else>
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
                                        <g:each in="${day.events}" var="event">
                                            <span class="event-title selectable-event"
                                                  data-event-id="${event.id}"
                                                  data-event-title="${event.title}"
                                                  data-event-date="${event.date}"
                                                  data-event-is-owner="${event.user.id == currentUser?.id ? 'true' : 'false'}"
                                                  style="cursor:pointer; user-select:text; background-color: ${event.user.id == currentUser?.id ? '#a663cc' : '#ff924c'}; color: white; padding: 2px 6px; border-radius: 4px; display: block; margin-bottom: 2px; width: 100%; box-sizing: border-box;">
                                                ${event.title}
                                                <g:if test="${event.user.id == currentUser?.id}">
                                                    <g:if test="${event.guests}">
                                                        <span style="font-size: 10px; display: block; opacity: 0.8;">
                                                            Invitados: ${event.guests.collect { it.username }.join(', ')}
                                                        </span>
                                                    </g:if>
                                                </g:if>
                                                <g:else>
                                                    <span style="font-size: 10px; display: block; opacity: 0.8;">
                                                        ${event?.user?.username ?: 'Desconocido'}
                                                        <g:if test="${event?.guests}">
                                                            <br/>${event.guests*.username.findAll().join(', ')}
                                                        </g:if>
                                                    </span>
                                                </g:else>
                                            </span>
                                        </g:each>
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

    <%-- Flecha derecha --%>
    <div class="arrow-block">
        <g:if test="${viewType == 'week'}">
        <%-- Si estamos en la última semana, al avanzar cambiamos de mes y week=0 --%>
            <g:if test="${weekIndex == totalWeeks - 1}">
                <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                    <input type="hidden" name="view" value="week"/>
                    <input type="hidden" name="country" value="${selectedCountry}"/>
                    <g:set var="nextMonth" value="${selectedMonth == 12 ? 1 : selectedMonth + 1}"/>
                    <g:set var="nextYear" value="${selectedMonth == 12 ? selectedYear + 1 : selectedYear}"/>
                    <input type="hidden" name="year" value="${nextYear}"/>
                    <input type="hidden" name="month" value="${nextMonth}"/>
                    <input type="hidden" name="week" value="0"/>
                    <button type="submit" class="arrow-btn">&#8594;</button>
                </form>
            </g:if>
            <g:else>
                <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                    <input type="hidden" name="year" value="${selectedYear}"/>
                    <input type="hidden" name="month" value="${selectedMonth}"/>
                    <input type="hidden" name="country" value="${selectedCountry}"/>
                    <input type="hidden" name="view" value="week"/>
                    <input type="hidden" name="week" value="${weekIndex + 1}"/>
                    <button type="submit" class="arrow-btn">&#8594;</button>
                </form>
            </g:else>
        </g:if>
        <g:else>
            <form method="get" action="${createLink(controller: 'calendar', action: 'index')}" style="height: 100%; display: flex; align-items: center; justify-content: center;">
                <input type="hidden" name="year" value="${selectedMonth == 12 ? selectedYear + 1 : selectedYear}"/>
                <input type="hidden" name="month" value="${selectedMonth == 12 ? 1 : selectedMonth + 1}"/>
                <input type="hidden" name="country" value="${selectedCountry}"/>
                <button type="submit" class="arrow-btn">&#8594;</button>
            </form>
        </g:else>
    </div>
</div>

<!-- Modal para editar/eliminar/abandonar evento -->
<div id="eventModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); background:#fff6e0; border:2px solid #a663cc; border-radius:10px; padding:20px; z-index:1000; min-width: 400px; max-width: 600px; max-height: 80vh; overflow-y: auto;">
    <form id="editEventForm" method="post" style="display: flex; flex-direction: column; gap: 15px;">
        <input type="hidden" name="id" id="modalEventId"/>
        <input type="hidden" id="modalEventIsOwner"/>

        <!-- Sección de detalles del evento -->
        <div id="editFields" style="flex: 1;">
            <label for="modalEventTitle">Título:</label>
            <input type="text" name="title" id="modalEventTitle" required style="width: 100%; margin-bottom: 10px;"/><br>
            <label for="modalEventDate">Fecha:</label>
            <input type="date" name="date" id="modalEventDate" required style="width: 100%;"/><br>
        </div>

        <div id="viewFields" style="display:none; flex: 1;">
            <label>Título:</label>
            <span id="modalEventTitleView"></span><br>
            <label>Fecha:</label>
            <span id="modalEventDateView"></span><br>
        </div>

        <div id="inviteField" style="flex: 1;">
            <label for="modalEventGuest">Invitar contacto:</label>
            <select name="guestEmail" id="modalEventGuest" style="width: 100%;">
                <option value="">-- Selecciona un contacto --</option>
                <g:each in="${contacts}" var="contact">
                    <option value="${contact.username}">${contact.username}</option>
                </g:each>
            </select>
        </div>

        <!-- Nueva sección de chat -->
        <div class="chat-section">
            <h4>Chat del Evento</h4>
            <div id="eventChatMessages" class="chat-messages"></div>
            <div class="message-form">
                <input type="text" id="eventMessageContent" class="message-input"
                       placeholder="Escribe un mensaje..."/>
                <button type="button" onclick="sendEventMessage()" class="send-button">Enviar</button>
            </div>
        </div>

        <!-- Botones de acción -->
        <div style="display: flex; gap: 10px; justify-content: center; margin-top: auto; border-top: 1px solid #e0c3fc; padding-top: 15px;">
            <button type="submit" id="saveEventBtn" style="background:#a663cc; color: white; padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer;">Guardar</button>
            <button type="button" id="deleteEventBtn" style="background:#e53935; color: white; padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer;">Eliminar/Abandonar</button>
            <button type="button" onclick="closeModal()" style="background:#ffb56b; color: #3d246c; padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer;">Cancelar</button>
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
        document.getElementById('modalEventId').value = eventData.id;

        if (isOwner) {
            document.getElementById('editFields').style.display = '';
            document.getElementById('inviteField').style.display = '';
            document.getElementById('viewFields').style.display = 'none';
            document.getElementById('modalEventTitle').value = eventData.title;
            document.getElementById('modalEventDate').value = eventData.date;
            // Mostrar el botón de guardar solo si es propietario
            document.getElementById('saveEventBtn').style.display = '';
        } else {
            document.getElementById('editFields').style.display = 'none';
            document.getElementById('inviteField').style.display = 'none';
            document.getElementById('viewFields').style.display = '';
            document.getElementById('modalEventTitleView').textContent = eventData.title;
            document.getElementById('modalEventDateView').textContent = eventData.date;
            // Ocultar el botón de guardar si no es propietario
            document.getElementById('saveEventBtn').style.display = 'none';
        }

        document.getElementById('eventModal').style.display = 'block';
        document.getElementById('modalOverlay').style.display = 'block';
        loadEventMessages(eventData.id);
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

    function loadEventMessages(eventId) {
        fetch('${createLink(controller:"event", action:"getEventMessages")}?eventId=' + eventId)
            .then(response => response.json())
            .then(messages => {
                const chatMessages = document.getElementById('eventChatMessages');
                chatMessages.innerHTML = '';
                let currentDate = '';

                messages.forEach(message => {
                    if (message.date !== currentDate) {
                        currentDate = message.date;
                        const dateDiv = document.createElement('div');
                        dateDiv.className = 'date-separator';
                        dateDiv.innerHTML = '<span>' + message.date + '</span>';
                        chatMessages.appendChild(dateDiv);
                    }

                    const messageDiv = document.createElement('div');
                    messageDiv.className = 'message ' + (message.isSent ? 'sent' : 'received');

                    let messageHTML = '';
                    // Mostrar email del usuario solo para mensajes recibidos (no enviados por el usuario actual)
                    if (!message.isSent && message.senderEmail) {
                        messageHTML += '<div class="message-username" style="font-size: 11px; color: #666; margin-bottom: 2px; font-weight: bold;">' + message.senderEmail + '</div>';
                    }

                    messageHTML += '<div class="message-content">' +
                        message.content +
                        '<span class="message-time">' + message.time + '</span>' +
                        '</div>';

                    messageDiv.innerHTML = messageHTML;
                    chatMessages.appendChild(messageDiv);
                });
                chatMessages.scrollTop = chatMessages.scrollHeight;
            });
    }

    function sendEventMessage() {
        const eventId = document.getElementById('modalEventId').value;
        const content = document.getElementById('eventMessageContent').value;
        if (!content.trim()) return;

        const formData = new FormData();
        formData.append('eventId', eventId);
        formData.append('content', content);

        fetch('${createLink(controller:"event", action:"sendEventMessage")}', {
            method: 'POST',
            body: formData
        }).then(response => {
            if (response.ok) {
                document.getElementById('eventMessageContent').value = '';
                loadEventMessages(eventId);
            }
        });
    }

    // Enviar mensaje al presionar Enter
    document.getElementById('eventMessageContent').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // Evita el comportamiento por defecto del formulario
            sendEventMessage(); // Envía el mensaje
        }
    });
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
    background: #ffb56b;
    height: 100%;
    min-width: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
}
.arrow-btn {
    background: none;
    border: none;
    font-size: 32px;
    color: #3d246c;
    cursor: pointer;
    height: 100%;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
    padding: 0;
}
.arrow-btn:hover {
    background: #ff924c;
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
.event-title {
    font-size: 11px !important;
    white-space: normal;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 100%;
    display: inline-block;
    line-height: 1.2;
    margin-bottom: 2px;
}

.event-list {
    position: absolute;
    bottom: 30px;
    left: 5px;
    max-height: 45%;
    width: calc(100% - 10px);
    overflow-y: auto;
    color: #4a148c;
    font-size: 13px;
    padding: 2px;
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
    position: relative;
    padding: 10px;
    height: 120px;
    overflow: hidden;
}

.holiday {
    position: absolute;
    bottom: 5px;
    left: 5px;
    right: 5px;
    font-size: 12px;
    color: #ff924c;
    font-weight: bold;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
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
#eventModal button {
    transition: all 0.3s ease;
}

#eventModal button:hover {
    opacity: 0.9;
    transform: translateY(-1px);
}

#deleteEventBtn:hover {
    background-color: #c62828 !important;
}

#eventModal input, #eventModal select {
    padding: 8px;
    border: 1px solid #a663cc;
    border-radius: 5px;
    margin-bottom: 10px;
}

#eventModal label {
    display: block;
    margin-bottom: 5px;
    color: #3d246c;
}
.chat-section {
    margin-top: 20px;
    border-top: 1px solid #e0c3fc;
    padding-top: 15px;
}

.chat-messages {
    height: 200px;
    overflow-y: auto;
    border: 1px solid #e0c3fc;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 10px;
    background: #fff;
}

.message {
    margin: 8px 0;
    padding: 8px 12px;
    border-radius: 8px;
    max-width: 80%;
    clear: both;
}

.message.sent {
    background: #a663cc;
    color: white;
    float: right;
}

.message.received {
    background: #f3e9ff;
    color: #3d246c;
    float: left;
}

.date-separator {
    text-align: center;
    margin: 15px 0;
    clear: both;
    position: relative;
}

.date-separator span {
    background: #fff;
    padding: 0 10px;
    color: #a663cc;
    position: relative;
    z-index: 1;
    font-size: 0.8em;
}

.message-form {
    display: flex;
    gap: 10px;
    margin-top: 10px;
}

.message-input {
    flex: 1;
    padding: 8px;
    border: 1px solid #e0c3fc;
    border-radius: 4px;
}

.send-button {
    background: #ffb56b;
    color: #3d246c;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
}
.message-time {
    font-size: 0.8em;
    opacity: 0.7;
    text-align: right;
    display: inline-block;
    margin-left: 8px;
    float: right;
}
</style>