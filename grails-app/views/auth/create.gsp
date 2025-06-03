<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registro</title>
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

    .register-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
        margin: 20px auto;
        width: 350px;
        padding: 20px;
        background-color: #fff6e0;
        box-shadow: 0 4px 8px rgba(166, 99, 204, 0.08);
        border-radius: 10px;
    }

    form label {
        font-weight: bold;
        color: #3d246c;
        width: 100%;
        text-align: left;
    }

    form input, form button {
        width: 100%;
        padding: 10px;
        border: 1px solid #ffb56b;
        border-radius: 5px;
        font-size: 14px;
        margin-bottom: 10px;
    }

    form button {
        background-color: #ffb56b;
        color: #3d246c;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    form button:hover {
        background-color: #ff924c;
    }

    .btn-back {
        background-color: #a663cc;
        color: #fff;
        margin-top: 10px;
        border: none;
        padding: 10px 0;
        border-radius: 5px;
        width: 100%;
        cursor: pointer;
        transition: background-color 0.3s;
        text-decoration: none;
        display: block;
        text-align: center;
    }
    .btn-back:hover {
        background-color: #3d246c;
    }

    .alert {
        background: #ffe0b2;
        color: #a663cc;
        border-radius: 5px;
        padding: 10px;
        margin-bottom: 10px;
        text-align: center;
    }
    </style>
</head>
<body>
<h1>Registro</h1>
<div class="register-container">
    <g:if test="${flash.message}">
        <div class="alert">${flash.message}</div>
    </g:if>
    <g:form action="save" method="POST" useToken="true">
        <label for="username">Correo Electrónico</label>
        <input type="email" name="username" value="${user?.username}" id="username" placeholder="Correo Electrónico"  required />

        <label for="password">Contraseña</label>
        <input type="password" name="password" id="password" placeholder=Contraseña required />

        <label for="password2">Contraseña (de nuevo)</label>
        <input type="password" name="password2" id="password2" placeholder="Contraseña" required />

        <button type="submit">Registrarse</button>
    </g:form>
    <g:link controller="auth" action="auth" class="btn-back">Volver</g:link>
</div>
</body>
</html>