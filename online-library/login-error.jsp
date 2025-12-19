<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ошибка входа</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2 style="color: #d9534f;">Ошибка входа</h2>
    <p>Неверное имя пользователя или пароль.</p>
    <div style="margin-top:20px;">
        <a href="${pageContext.request.contextPath}/login.jsp">Попробовать снова</a>
    </div>
</div>
</body>
</html>