<!DOCTYPE html>
<html>
<head>
    <title>Nuevo Evento</title>
</head>
<body>
<h2>Crear Evento</h2>
<g:form controller="event" action="save">
    <label for="title">Título:</label>
    <input type="text" name="title" required />
    <br>
    <label for="date">Fecha:</label>
    <input type="date" name="date" required />
    <br>
    <button type="submit">Guardar</button>
</g:form>
<g:link controller="calendar" action="index">Volver al calendario</g:link>
</body>
</html>