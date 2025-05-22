<!DOCTYPE html>
<html>
<head>
    <title>CALENDAR - Login</title>
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

    form {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
        margin: 20px auto;
        width: 300px;
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

    .login__signup {
        text-align: center;
        font-size: 14px;
        color: #555;
    }

    .login__signup a {
        color: #a663cc;
        text-decoration: none;
    }

    .login__signup a:hover {
        text-decoration: underline;
    }
    </style>
</head>
<body>
<h1>Iniciar Sesión</h1>
<form action="${request.contextPath}/login/authenticate" method="POST" id="loginForm" autocomplete="off">
    <label for="username">Correo Electrónico:</label>
    <input type="email" id="username" name="username" placeholder="Email" required autofocus />

    <label for="password">Contraseña:</label>
    <input type="password" id="password" name="password" placeholder="Contraseña" required />

    <button type="submit">Entrar</button>

    <p class="login__signup">
        <g:link controller="home" action="index">Cancelar</g:link>
    </p>

    <p class="login__signup">
        ¿No tienes cuenta?
        <g:link controller="auth" action="create">Regístrate aquí</g:link>
    </p>
</form>

<p class="login__signup">
    Usuario1: <strong>admin@cal.dev</strong><br>
    Usuario2: <strong>user@cal.dev</strong><br>
    Contraseña: <strong>1234</strong>
</p>
</body>
</html>