<%@ page contentType="text/html;charset=UTF-8" %>
<%-- grails-app/views/contact/_chat.gsp --%>
<div class="chat-contact-name">${contact.username}</div>
<div class="chat-messages">
    <g:each in="${messagesByDate}" var="entry">
        <div class="date-separator">
            <span>
                <g:formatDate date="${entry.key.atStartOfDay().toDate()}" format="d 'de' MMMM, yyyy"/>
            </span>
        </div>
        <g:each in="${entry.value}" var="message">
            <div class="message ${message.sender.id == currentUser.id ? 'sent' : 'received'}">
                <div class="message-content">
                    ${message.content}
                    <span class="message-time">${message.getFormattedTime()}</span>
                </div>
            </div>
        </g:each>
    </g:each>
</div>

<style>
.date-separator {
    text-align: center;
    margin: 20px 0;
    position: relative;
}

.date-separator span {
    background: #fff6e0;
    padding: 0 10px;
    color: #a663cc;
    font-size: 12px;
}

.date-separator:before {
    content: '';
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 1px;
    background: #e0c3fc;
    z-index: -1;
}

.message-time {
    font-size: 11px;
    color: #666;
    margin-left: 8px;
    float: right;
}

.message {
    margin-bottom: 10px;
}

.message-content {
    padding: 8px 12px;
    border-radius: 8px;
    display: inline-block;
    max-width: 70%;
}

.sent .message-content {
    background: #a663cc;
    color: white;
    float: right;
}

.received .message-content {
    background: #e0c3fc;
    color: #3d246c;
    float: left;
}

.chat-messages {
    overflow-y: auto;
    padding: 15px;
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