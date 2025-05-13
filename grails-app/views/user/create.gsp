<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>ROPLISP - Register</title>
</head>
<body>

<g:if test="${flash.message}">
    <div class="text-center alert alert-warning" role="alert">${flash.message}</div>
</g:if>

<div class="container-fluid game-rules">
    <h1>Register</h1>
    <g:form action="save" method="POST" useToken="true">
        <div class="row">
            <div class="form-group form-group-username col-12 mt-4">
                <label for="username"><g:message code="user.username.label" /></label>
                <input type="email" name="username" value="${user?.username}" class="form-control" id="username" placeholder="${message(code: 'user.username.label')}" />
            </div>
            <div class="form-group form-group-password col-12 mt-4">
                <label for="password"><g:message code="user.password.label" /></label>
                <input type="password" name="password" value="" class="form-control" id="password" placeholder="${message(code: 'user.password.label')}" />
            </div>
            <div class="form-group form-group-password col-12 mt-4">
                <label for="password"><g:message code="user.password.label" /> (again)</label>
                <input type="password" name="password2" value="" class="form-control" id="password2" placeholder="${message(code: 'user.password.label')}" />
            </div>
        </div>
        <div class="row mt-4">
            <input type="submit" value="REGISTER" class="btn btn-primary">
        </div>
    </g:form>
</div>
</body>
</html>