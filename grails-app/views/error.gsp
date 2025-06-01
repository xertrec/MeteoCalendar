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
    }

    .contacts-container {
        max-width: 800px;
        margin: 0 auto;
        background: #fff6e0;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(166, 99, 204, 0.08);
    }

    .contact-list {
        list-style: none;
        padding: 0;
    }

    .contact-item {
        padding: 10px;
        border-bottom: 1px solid #e0c3fc;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .contact-item:hover {
        background-color: #e0c3fc;
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
<div class="contacts-container">
    <h2>Mis Contactos</h2>
    <ul class="contact-list">
        <g:each in="${contacts}" var="contact">
            <li class="contact-item" onclick="openChat('${contact.id}', '${contact.username}')">${contact.username}</li>
        </g:each>
    </ul>
    <g:link controller="calendar" action="index">Volver al calendario</g:link>
</div>

<div id="chatModal" class="chat-modal">
    <button class="close-button" onclick="closeChat()">×</button>
    <h3 id="chatTitle"></h3>
    <div id="chatMessages" class="chat-messages">
        <!-- Los mensajes se cargarán aquí -->
    </div>
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

package org.udl

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class ContactController {

    def springSecurityService

    def index() {
        def user = springSecurityService.currentUser
        [contacts: user?.contacts ?: [], currentUser: user]
    }

    def search() {
        def searchTerm = params.email
        def currentUser = springSecurityService.currentUser
        def results = []

        if (searchTerm && searchTerm != currentUser.username) {
            results = User.findAllByUsernameIlike("%${searchTerm}%").findAll { it.id != currentUser.id }
        }

        render(template: 'searchResults', model: [results: results])
    }

    def add() {
        def currentUser = springSecurityService.currentUser
        def contactToAdd = User.get(params.id)

        if (contactToAdd && !currentUser.contacts.contains(contactToAdd)) {
            currentUser.addToContacts(contactToAdd)
            currentUser.save(flush: true)
            flash.message = "Contacto añadido correctamente"
        }

        redirect(action: 'index')
    }

    def remove() {
        def currentUser = springSecurityService.currentUser
        def contactToRemove = User.get(params.id)

        if (contactToRemove && currentUser.contacts.contains(contactToRemove)) {
            currentUser.removeFromContacts(contactToRemove)
            currentUser.save(flush: true)
            flash.message = "Contacto eliminado correctamente"
        }

        redirect(action: 'index')
    }

    def sendMessage() {
        def currentUser = springSecurityService.currentUser
        def receiver = User.get(params.receiverId)

        if (!receiver) {
            render status: 404
            return
        }

        def message = new Message(
                sender: currentUser,
                receiver: receiver,
                content: params.content
        )

        if (message.save(flush: true)) {
            render status: 200
        } else {
            render status: 400
        }
    }

    def getMessages() {
        def currentUser = springSecurityService.currentUser
        def contact = User.get(params.contactId)

        if (!contact) {
            render status: 404
            return
        }

        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }

        def messageList = messages.collect { msg ->
            [
                    content: msg.content,
                    isSent: msg.sender.id == currentUser.id,
                    time: msg.formattedTime
            ]
        }

        render messageList as grails.converters.JSON
    }

    def chat(String id) {
        def contact = User.get(id)
        if (!contact) {
            render status: 404
            return
        }

        def currentUser = springSecurityService.currentUser
        def messages = Message.findAll {
            (sender == currentUser && receiver == contact) ||
                    (sender == contact && receiver == currentUser)
        }

        if (params.ajax) {
            render template: "chat", model: [
                    contact: contact,
                    messages: messages
            ]
        } else {
            [contact: contact, messages: messages]
        }
    }
}