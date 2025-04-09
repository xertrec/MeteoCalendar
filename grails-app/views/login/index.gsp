<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Iniciar Sesión</title>
    </head>
    <body>
        <h1>Iniciar Sesión</h1>
        <form action="/login" method="post">
            <label for="username">Usuario:</label>
            <input type="text" id="username" name="username" required>
            <br>
            <label for="password">Contraseña:</label>
            <input type="password" id="password" name="password" required>
            <br>
            <button type="submit">Iniciar Sesión</button>
        </form>
    </body>
</html>