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
        padding: 0;
        color: #3d246c;
    }
    h1 {
        text-align: center;
        color: #a663cc;
        margin-top: 20px;
        font-size: 24px;
    }
    .contacts-container {
        width: 350px;
        margin: 30px auto;
        background: #fff6e0;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(166, 99, 204, 0.08);
        padding: 20px;
    }
    .contact-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .contact-item {
        padding: 10px;
        border-bottom: 1px solid #e0c3fc;
        cursor: pointer;
        color: #3d246c;
        transition: background 0.2s;
    }
    .contact-item:hover {
        background: #e0c3fc;
    }
    .add-contact-form {
        margin-top: 20px;
        display: flex;
        gap: 10px;
    }
    .add-contact-form input {
        flex: 1;
        padding: 8px;
        border: 1px solid #ffb56b;
        border-radius: 5px;
    }
    .add-contact-form button {
        background-color: #ffb56b;
        color: #3d246c;
        border: none;
        border-radius: 5px;
        padding: 8px 12px;
        cursor: pointer;
        transition: background 0.3s;
    }
    .add-contact-form button:hover {
        background-color: #ff924c;
    }
    .alert {
        background: #ffe0b2;
        color: #a663cc;
        border-radius: 5px;
        padding: 10px;
        margin-bottom: 10px;
        text-align: center;
    }
    .chat-modal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: #fff6e0;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        width: 80%;
        max-width: 500px;
        z-index: 1000;
    }
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 999;
    }
    .chat-messages {
        height: 300px;
        overflow-y: auto;
        border: 1px solid #e0c3fc;
        padding: 10px;
        margin-bottom: 10px;
        background: white;
    }
    .message {
        margin: 5px 0;
        padding: 5px 10px;
        border-radius: 10px;
    }
    .message.sent {
        background: #a663cc;
        color: white;
        margin-left: 20%;
    }
    .message.received {
        background: #e0c3fc;
        margin-right: 20%;
    }
    .message-form {
        display: flex;
        gap: 10px;
    }
    .message-input {
        flex-grow: 1;
        padding: 8px;
        border: 1px solid #ffb56b;
        border-radius: 5px;
    }
    .send-button {
        padding: 8px 16px;
        background: #ffb56b;
        border: none;
        border-radius: 5px;
        color: #3d246c;
        cursor: pointer;
    }
    .send-button:hover {
        background: #ff924c;
    }
    .close-button {
        position: absolute;
        top: 10px;
        right: 10px;
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: #3d246c;
    }
    </style>
</head>
<body>
<h1>Contactos</h1>
<div class="contacts-container">
    <g:if test="${flash.message}">
        <div class="alert">${flash.message}</div>
    </g:if>
    <ul class="contact-list">
        <g:each in="${contacts}" var="contact">
            <li class="contact-item" data-contact-id="${contact.id}">
                ${contact.username}
                <g:link action="remove" params="[id: contact.id]" style="float:right; color:#e53935; margin-left:10px;">Eliminar</g:link>
                <button type="button" onclick="openChat('${contact.id}', '${contact.username}')" style="float:right; background:none; border:none; color:#a663cc; cursor:pointer;">💬</button>
            </li>
        </g:each>
    </ul>
    <form class="add-contact-form" action="${createLink(action:'add')}" method="post">
        <input type="email" name="email" placeholder="Correo del contacto" required />
        <button type="submit">Agregar</button>
    </form>
    <g:link controller="calendar" action="index" class="btn-back" style="display:block; margin-top:20px; text-align:center;">Volver al calendario</g:link>
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
            .then(response => response.json())
            .then(messages => {
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.innerHTML = '';
                messages.forEach(message => {
                    const messageDiv = document.createElement('div');
                    messageDiv.className = 'message ' + (message.isSent ? 'sent' : 'received');
                    messageDiv.textContent = message.content;
                    chatMessages.appendChild(messageDiv);
                });
                chatMessages.scrollTop = chatMessages.scrollHeight;
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