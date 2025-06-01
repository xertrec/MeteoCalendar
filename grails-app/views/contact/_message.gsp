<div class="message ${message.sender.id == currentUser.id ? 'sent' : 'received'}">
    <div class="message-content">
        <p>${message.content}</p>
        <small class="message-time">
            <g:formatDate date="${message.sentAt}" format="dd/MM/yyyy HH:mm"/>
        </small>
    </div>
</div>

<style>
.message {
    max-width: 70%;
    margin: 5px 0;
    padding: 8px 12px;
    border-radius: 12px;
}

.message.sent {
    align-self: flex-end;
    background: #ffb56b;
    color: white;
}

.message.received {
    align-self: flex-start;
    background: #f0f0f0;
    color: #333;
}

.message-content {
    margin-bottom: 4px;
    word-wrap: break-word;
}

.message-time {
    font-size: 0.8em;
    opacity: 0.7;
    text-align: right;
}
</style>