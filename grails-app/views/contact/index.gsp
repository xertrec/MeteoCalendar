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
    #floating-chat {
        display: none;
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 350px;
        z-index: 2000;
        background: #fff6e0;
        border: 2px solid #a663cc;
        border-radius: 10px;
        box-shadow: 0 4px 16px rgba(166, 99, 204, 0.18);
    }
    #floating-chat .chat-header {
        background: #a663cc;
        color: #fff;
        padding: 10px;
        border-radius: 10px 10px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    #floating-chat .chat-messages {
        max-height: 300px;
        overflow-y: auto;
        padding: 10px;
        background: #fff;
    }
    #floating-chat .chat-form {
        display: flex;
        border-top: 1px solid #e0c3fc;
        padding: 10px;
        background: #fff6e0;
    }
    #floating-chat .chat-form input {
        flex: 1;
        border: 1px solid #ffb56b;
        border-radius: 5px;
        padding: 8px;
    }
    #floating-chat .chat-form button {
        background: #ffb56b;
        color: #3d246c;
        border: none;
        border-radius: 5px;
        padding: 8px 12px;
        margin-left: 5px;
        cursor: pointer;
    }
    #floating-chat .chat-form button:hover {
        background: #ff924c;
    }
    #floating-chat .close-btn {
        background: none;
        border: none;
        color: #fff;
        font-size: 18px;
        cursor: pointer;
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
                <button type="button" class="open-chat-btn" data-contact-id="${contact.id}" style="float:right; background:none; border:none; color:#a663cc; cursor:pointer;">💬</button>
            </li>
        </g:each>
    </ul>
    <form class="add-contact-form" action="${createLink(action:'add')}" method="post">
        <input type="email" name="email" placeholder="Correo del contacto" required />
        <button type="submit">Agregar</button>
    </form>
    <g:link controller="calendar" action="index" class="btn-back" style="display:block; margin-top:20px; text-align:center;">Volver al calendario</g:link>
</div>

<div id="floating-chat"></div>

<script>
    // Abrir chat flotante al hacer clic en el botón 💬
    document.querySelectorAll('.open-chat-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const contactId = this.dataset.contactId;
            openFloatingChat(contactId);
        });
    });

    function openFloatingChat(contactId) {
        const chatDiv = document.getElementById('floating-chat');
        chatDiv.innerHTML = '<div class="chat-header">Cargando chat...<button class="close-btn" onclick="closeFloatingChat()">×</button></div>';
        chatDiv.style.display = 'block';

        fetch('${createLink(controller:"contact", action:"chat")}/' + contactId + '?ajax=true')
            .then(resp => resp.text())
            .then(html => {
                chatDiv.innerHTML = `
                <div class="chat-header">
                    Chat con <span id="chat-contact-name"></span>
                    <button class="close-btn" onclick="closeFloatingChat()">×</button>
                </div>
                <div class="chat-messages" id="chat-messages"></div>
                <form class="chat-form" id="chatForm" autocomplete="off">
                    <input type="hidden" name="receiverId" value="${contactId}" />
                    <input type="text" name="content" id="chatInput" placeholder="Escribe un mensaje..." required />
                    <button type="submit">Enviar</button>
                </form>
            `;

                // Insertar mensajes y nombre
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = html;
                const messages = tempDiv.querySelector('.chat-messages') || tempDiv;
                document.getElementById('chat-messages').innerHTML = messages.innerHTML;
                const contactName = tempDiv.querySelector('.chat-contact-name') ?
                    tempDiv.querySelector('.chat-contact-name').textContent : '';
                document.getElementById('chat-contact-name').textContent = contactName;

                // Scroll al final
                const msgDiv = document.getElementById('chat-messages');
                msgDiv.scrollTop = msgDiv.scrollHeight;

                // Configurar el manejador del formulario de chat
                document.getElementById('chatForm').onsubmit = function(ev) {
                    ev.preventDefault();
                    const formData = new FormData(this);
                    formData.append('ajax', 'true');

                    fetch('${createLink(controller:"contact", action:"sendMessage")}', {
                        method: 'POST',
                        body: new URLSearchParams(formData)
                    })
                        .then(resp => resp.text())
                        .then(html => {
                            const tempDiv = document.createElement('div');
                            tempDiv.innerHTML = html;
                            const newMessages = tempDiv.querySelector('.chat-messages') || tempDiv;
                            document.getElementById('chat-messages').innerHTML = newMessages.innerHTML;
                            document.getElementById('chatInput').value = '';
                            msgDiv.scrollTop = msgDiv.scrollHeight;
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Error al enviar el mensaje');
                        });
                };
            });
    }

    function closeFloatingChat() {
        document.getElementById('floating-chat').style.display = 'none';
        document.getElementById('floating-chat').innerHTML = '';
    }

    document.getElementById('chatForm').onsubmit = function(ev) {
        ev.preventDefault();
        const formData = new FormData(this);

        fetch('${createLink(controller:"contact", action:"sendMessage")}', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta del servidor');
                }
                return response.text();
            })
            .then(html => {
                const chatMessages = document.getElementById('chat-messages');
                chatMessages.innerHTML = html;
                chatMessages.scrollTop = chatMessages.scrollHeight;
                document.getElementById('chatInput').value = '';
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al enviar el mensaje');
            });
    };

</script>
</body>
</html>