<!DOCTYPE html>
<html>
<head>
    <title>Nuevo Evento</title>
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
    .event-container {
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
    </style>
</head>
<body>
<h1>Nuevo Evento</h1>
<div class="event-container">
    <g:form controller="event" action="save" method="POST">
        <label for="title">Título:</label>
        <input type="text" name="title" id="title" required />

        <label for="date">Fecha:</label>
        <input type="date" name="date" id="date" required />

        <button type="submit">Guardar</button>
    </g:form>
    <g:link controller="calendar" action="index" class="btn-back">Volver al calendario</g:link>
</div>
</body>
</html>