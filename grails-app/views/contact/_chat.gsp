<%@ page contentType="text/html;charset=UTF-8" %>
<%-- grails-app/views/contact/_chat.gsp --%>
<div class="chat-contact-name">${contact.username}</div>
<div class="chat-messages">
    <g:each in="${messages}" var="msg">
        <div style="margin: 5px 0; ${msg.sender.id == session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id ? 'text-align: right; color: #a663cc;' : 'text-align: left; color: #3d246c;'}">
            <small style="font-size: 0.8em; opacity: 0.7;">
                ${msg.formattedTime}
            </small>
            <div style="background: ${msg.sender.id == session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id ? '#f3e9ff' : '#ffe0b2'};
            display: inline-block;
            padding: 5px 10px;
            border-radius: 10px;
            max-width: 80%;">
                ${msg.content}
            </div>
        </div>
    </g:each>
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