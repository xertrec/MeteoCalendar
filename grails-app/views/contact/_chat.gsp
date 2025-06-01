<%@ page contentType="text/html;charset=UTF-8" %>
<div id="chat-container" class="chat-container">
    <div class="chat-header">
        <h3>${contact.username}</h3>
    </div>

    <div id="messages-container" class="messages-container">
        <g:each in="${messages}" var="message">
            <g:render template="message" model="[message: message, currentUser: currentUser]"/>
        </g:each>
    </div>

    <div class="chat-input">
        <form id="message-form" onsubmit="sendMessage(event)">
            <input type="hidden" id="receiverId" value="${contact.id}"/>
            <input type="text" id="message-content" placeholder="Escribe un mensaje..." required/>
            <button type="submit">Enviar</button>
        </form>
    </div>
</div>

<style>
.chat-container {
    display: flex;
    flex-direction: column;
    height: 100%;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.chat-header {
    padding: 15px;
    background: #a663cc;
    color: white;
    border-radius: 8px 8px 0 0;
}

.messages-container {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.chat-input {
    padding: 15px;
    border-top: 1px solid #eee;
}

.chat-input form {
    display: flex;
    gap: 10px;
}

.chat-input input {
    flex: 1;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.chat-input button {
    padding: 8px 16px;
    background: #ffb56b;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.chat-input button:hover {
    background: #ff924c;
}
</style>

<script>
    function sendMessage(event) {
        event.preventDefault();
        const form = event.target;
        const content = document.getElementById('message-content').value;
        const receiverId = document.getElementById('receiverId').value;

        fetch('${createLink(controller: "contact", action: "sendMessage")}', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `receiverId=${receiverId}&content=${encodeURIComponent(content)}`
        })
            .then(response => response.text())
            .then(html => {
                const messagesContainer = document.getElementById('messages-container');
                messagesContainer.insertAdjacentHTML('beforeend', html);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
                form.reset();
            });
    }
</script>