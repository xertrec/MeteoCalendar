<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contactos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f3e9ff;
        margin: 0;
        padding: 20px;
        color: #3d246c;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    h1 {
        color: #a663cc;
        font-size: 2rem;
        margin: 1.5rem 0;
        text-transform: uppercase;
        letter-spacing: 2px;
        font-weight: bold;
    }

    .contacts-container {
        width: 90%;
        max-width: 600px;
        background: #fff6e0;
        border-radius: 20px;
        box-shadow: 0 8px 16px rgba(166, 99, 204, 0.15);
        padding: 2rem;
        margin: 0 auto;
    }

    .alert {
        background: linear-gradient(45deg, #ffe0b2, #fff6e0);
        color: #a663cc;
        border-radius: 10px;
        padding: 1rem;
        margin-bottom: 1.5rem;
        text-align: center;
        font-weight: 500;
        box-shadow: 0 2px 4px rgba(166, 99, 204, 0.1);
    }

    /* Lista de contactos */
    .contact-list {
        list-style: none;
        padding: 0;
        margin: 0;
        border-radius: 10px;
        overflow: hidden;
    }

    .contact-item {
        padding: 1rem 1.5rem;
        border-bottom: 2px solid #e0c3fc;
        display: flex;
        align-items: center;
        justify-content: space-between;
        transition: all 0.3s ease;
    }

    .contact-item:last-child {
        border-bottom: none;
    }

    .contact-item:hover {
        background: linear-gradient(45deg, #e0c3fc, #f3e9ff);
        transform: translateX(5px);
    }

    /* Botones de contacto */
    .contact-actions {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .contact-button {
        background: none;
        border: none;
        padding: 0.5rem;
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .contact-button:hover {
        transform: scale(1.2);
    }

    .chat-button {
        color: #a663cc;
        font-size: 1.2rem;
    }

    .remove-button {
        color: #e53935;
        text-decoration: none;
        font-size: 0.9rem;
    }

    /* Formulario de agregar contacto */
    .add-contact-form {
        margin-top: 2rem;
        display: flex;
        gap: 1rem;
        background: white;
        padding: 1rem;
        border-radius: 15px;
        box-shadow: 0 2px 8px rgba(166, 99, 204, 0.1);
    }

    .add-contact-form input {
        flex: 1;
        padding: 0.8rem 1rem;
        border: 2px solid #ffb56b;
        border-radius: 10px;
        font-size: 1rem;
        transition: border-color 0.3s ease;
    }

    .add-contact-form input:focus {
        outline: none;
        border-color: #a663cc;
    }

    .add-contact-form button {
        background: linear-gradient(45deg, #ffb56b, #ff924c);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 0.8rem 1.5rem;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .add-contact-form button:hover {
        transform: translateY(-2px);
    }

    /* Modal de chat */
    .chat-modal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: #fff6e0;
        padding: 2rem;
        border-radius: 20px;
        box-shadow: 0 12px 24px rgba(0,0,0,0.2);
        width: 90%;
        max-width: 600px;
        z-index: 1000;
    }

    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(61, 36, 108, 0.5);
        backdrop-filter: blur(4px);
        z-index: 999;
    }

    /* Chat messages */
    .chat-messages {
        height: 400px;
        overflow-y: auto;
        border: 2px solid #e0c3fc;
        border-radius: 15px;
        padding: 1.5rem;
        margin: 1.5rem 0;
        background: white;
    }

    .message {
        margin: 0.8rem 0;
        padding: 0.8rem 1.2rem;
        border-radius: 15px;
        max-width: 80%;
        clear: both;
        word-wrap: break-word;
    }

    .message.sent {
        background: linear-gradient(45deg, #a663cc, #9152b6);
        color: white;
        float: right;
    }

    .message.received {
        background: linear-gradient(45deg, #e0c3fc, #d4b4f8);
        float: left;
    }

    .message-time {
        font-size: 11px;
        opacity: 0.8;
        margin-left: 8px;
        display: inline-block;
    }

    /* Date separator */
    .date-separator {
        text-align: center;
        margin: 20px 0;
        position: relative;
        clear: both;
    }

    .date-separator span {
        background: #fff6e0;
        padding: 0 10px;
        color: #a663cc;
        font-size: 12px;
        position: relative;
        z-index: 1;
    }

    .date-separator:before {
        content: '';
        position: absolute;
        top: 50%;
        left: 0;
        right: 0;
        height: 1px;
        background: #e0c3fc;
        z-index: 0;
    }

    /* Message form */
    .message-form {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
    }

    .message-input {
        flex: 1;
        padding: 1rem;
        border: 2px solid #ffb56b;
        border-radius: 15px;
        font-size: 1rem;
        transition: all 0.3s ease;
    }

    .message-input:focus {
        outline: none;
        border-color: #a663cc;
    }

    .send-button {
        padding: 1rem 2rem;
        background: linear-gradient(45deg, #ffb56b, #ff924c);
        color: white;
        border: none;
        border-radius: 15px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .send-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(255, 181, 107, 0.3);
    }

    .close-button {
        position: absolute;
        top: 1rem;
        right: 1rem;
        background: none;
        border: none;
        font-size: 1.5rem;
        color: #3d246c;
        cursor: pointer;
        transition: transform 0.2s ease;
    }

    .close-button:hover {
        transform: scale(1.2);
    }
    </style>
</head>
<body>
<!-- Topbar con botones y usuario -->
<div style="display: flex; justify-content: space-between; align-items: center; width: 80%; margin: 30px auto 0 auto; padding: 10px 0;">
    <div style="display: flex; gap: 10px;">
        <g:link controller="calendar" action="index" class="btn btn-secondary">
            <button type="button" style="padding:8px 16px; border:1px solid #a663cc;
            border-radius:5px; font-size:14px; background-color:#a663cc; color:#fff;
            cursor:pointer;">Volver al calendario</button>
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
<h1>Contactos</h1>
<div class="contacts-container">
    <g:if test="${flash.message}">
        <div class="alert">${flash.message}</div>
    </g:if>
    <ul class="contact-list">
        <g:each in="${contacts}" var="contact">
            <li class="contact-item">
                ${contact.username}
                <div class="contact-actions">
                    <button type="button" onclick="openChat('${contact.id}', '${contact.username}')" class="contact-button chat-button">💬</button>
                    <g:link action="remove" params="[id: contact.id]" class="contact-button remove-button">×</g:link>
                </div>
            </li>
        </g:each>
    </ul>
    <form class="add-contact-form" action="${createLink(action:'add')}" method="post">
        <input type="email" name="email" placeholder="Correo del contacto" required />
        <button type="submit">Agregar</button>
    </form>
</div>

<div id="chatModal" class="chat-modal">
    <button class="close-button" onclick="closeChat()">×</button>
    <h3 id="chatTitle"></h3>
    <div id="chatMessages" class="chat-messages"></div>
    <form id="messageForm" class="message-form" onsubmit="sendMessage(event)">
        <input type="hidden" id="receiverId" name="receiverId" />
        <input type="text" id="messageContent" name="content" class="message-input" placeholder="Escribe un mensaje..." required />
        <button type="submit" class="send-button">Enviar</button>
    </form>
</div>

<div id="modalOverlay" class="modal-overlay" onclick="closeChat()"></div>

<script>
    function openChat(contactId, contactName) {
        document.getElementById('receiverId').value = contactId;
        document.getElementById('chatTitle').textContent = 'Chat con ' + contactName;
        document.getElementById('chatModal').style.display = 'block';
        document.getElementById('modalOverlay').style.display = 'block';
        loadMessages(contactId);
    }

    function closeChat() {
        document.getElementById('chatModal').style.display = 'none';
        document.getElementById('modalOverlay').style.display = 'none';
    }

    function loadMessages(contactId) {
        fetch('${createLink(controller:"contact", action:"getMessages")}?contactId=' + contactId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta del servidor');
                }
                return response.json();
            })
            .then(messages => {
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.innerHTML = '';
                let currentDate = '';

                if (Array.isArray(messages)) {
                    messages.forEach(message => {
                        if (message && message.date) {
                            if (message.date !== currentDate) {
                                currentDate = message.date;
                                const dateDiv = document.createElement('div');
                                dateDiv.className = 'date-separator';
                                dateDiv.innerHTML = '<span>' + (message.date || '') + '</span>';
                                chatMessages.appendChild(dateDiv);
                            }

                            const messageDiv = document.createElement('div');
                            messageDiv.className = 'message ' + (message.isSent ? 'sent' : 'received');
                            messageDiv.innerHTML =
                                '<div class="message-content">' +
                                (message.content || '') +
                                '<span class="message-time">' + (message.time || '') + '</span>' +
                                '</div>';
                            chatMessages.appendChild(messageDiv);
                        }
                    });
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                }
            })
            .catch(error => {
                console.error('Error al cargar los mensajes:', error);
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.innerHTML = '<div class="alert">Error al cargar los mensajes</div>';
            });
    }

    function sendMessage(event) {
        event.preventDefault();
        const form = event.target;
        const formData = new FormData(form);

        fetch('${createLink(controller:"contact", action:"sendMessage")}', {
            method: 'POST',
            body: formData
        }).then(response => {
            if (response.ok) {
                form.reset();
                loadMessages(document.getElementById('receiverId').value);
            }
        });
    }
</script>
</body>
</html>