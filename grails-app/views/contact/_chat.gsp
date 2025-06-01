<%@ page contentType="text/html;charset=UTF-8" %>
<div class="chat-messages">
    <g:if test="${error}">
        <div class="alert">${error}</div>
    </g:if>
    <g:each in="${messages}" var="msg">
        <div style="margin-bottom:8px;${msg.sender?.id == currentUser?.id ? 'text-align:right;' : 'text-align:left;'}">
            <span style="background:${msg.sender?.id == currentUser?.id ? '#a663cc' : '#ffb56b'};color:#fff;padding:6px 12px;border-radius:8px;display:inline-block;">
                ${msg.content}
            </span>
            <span style="font-size:10px;color:#888;margin-left:5px;">
                ${msg.sentAt?.format('HH:mm')}
            </span>
        </div>
    </g:each>
</div>
<form class="chat-form" id="chatForm" autocomplete="off" style="display:flex; border-top:1px solid #e0c3fc; padding:10px; background:#fff6e0;">
    <input type="hidden" name="receiverId" value="${contact?.id}" />
    <input type="text" name="content" id="chatInput" placeholder="Escribe un mensaje..." required autocomplete="off" style="flex:1; border:1px solid #ffb56b; border-radius:5px; padding:8px;" />
    <button type="submit" style="background-color:#ffb56b; color:#3d246c; border:none; border-radius:5px; padding:8px 12px; margin-left:5px; cursor:pointer;">Enviar</button>
</form>
<script>
    // Intercepta el envío del formulario para usar AJAX
    document.getElementById('chatForm').onsubmit = function(e) {
        e.preventDefault();
        const form = this;
        const contactId = form.receiverId.value;
        const formData = new FormData(form);
        fetch('/contact/sendMessage', {
            method: 'POST',
            body: formData
        })
            .then(() => {
                // Recarga solo el chat después de enviar
                fetch('/contact/chat/' + contactId + '?ajax=1')
                    .then(response => response.text())
                    .then(html => {
                        document.getElementById('floating-chat').innerHTML = html;
                        document.getElementById('floating-chat').style.display = 'block';
                    });
                form.reset();
            });
    };
</script>
<style>
.floating-chat-container { width: 350px; }
.chat-history { max-height: 300px; overflow-y: auto; margin-bottom: 10px; }
.message { margin-bottom: 10px; padding: 6px 10px; border-radius: 8px; max-width: 80%; }
.from-me { background: #e1d5fa; color: #a663cc; text-align: right; margin-left: auto; }
.from-them { background: #ffe0b2; color: #3d246c; text-align: left; margin-right: auto; }
.chat-form { display: flex; gap: 10px; margin-top: 15px; }
input, button { padding: 8px; border-radius: 5px; border: 1px solid #ffb56b; }
button { background: #ffb56b; color: #3d246c; cursor: pointer; }
</style>