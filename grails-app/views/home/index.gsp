<!DOCTYPE html>
<html>
<head>
    <title>CALENDAR - Home</title>
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

    .home-container {
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

    .home-container button {
        width: 100%;
        padding: 10px;
        border: 1px solid #ffb56b;
        border-radius: 5px;
        font-size: 14px;
        background-color: #ffb56b;
        color: #3d246c;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .home-container button:hover {
        background-color: #ff924c;
    }
    </style>
</head>
<body>
<h1>Bienvenido</h1>
<div class="home-container">
    <g:link controller="login" action="auth" class="btn btn-primary">
        <button>Log In</button>
    </g:link>
</div>
</body>
</html>