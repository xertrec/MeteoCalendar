<div class="message ${message.sender.id == currentUser.id ? 'sent' : 'received'}">
    <div class="message ${message.sender.id == currentUser.id ? 'sent' : 'received'}">
        ${message.content}
        <span class="message-time">${message.getFormattedTime()}</span>
    </div>
</div>

<style>
.message {
    margin-bottom: 10px;
    clear: both;
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

.message-info {
    font-size: 11px;
    margin-top: 4px;
}

.message-sender {
    color: inherit;
    opacity: 0.8;
}

.message-time {
    float: right;
    opacity: 0.7;
}
</style>