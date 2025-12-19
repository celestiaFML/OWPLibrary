<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Вход</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
  <h2>Вход в онлайн библиотеку</h2>

  <form method="post" action="${pageContext.request.contextPath}/login">
    <label>Логин:
      <input type="text" name="username" autofocus required>
    </label>

    <label>Пароль:
      <input type="password" name="password" required>
    </label>

    <button type="submit">Войти</button>
  </form>

  <c:if test="${not empty error}">
    <p style="color:red">${error}</p>
  </c:if>

  <p><a href="${pageContext.request.contextPath}/">На главную</a></p>
</div>
</body>
</html>