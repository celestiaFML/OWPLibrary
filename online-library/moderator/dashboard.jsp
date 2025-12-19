<%@ page contentType="text/html; charset=UTF-8" %>
<%
    java.util.Set roles = (java.util.Set) session.getAttribute("roles");
    String user = (String) session.getAttribute("user");

    if (user == null || roles == null ||
        !(roles.contains("moderator") || roles.contains("admin"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Панель модератора</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/user/cabinet.jsp">Кабинет</a>
    <a href="${pageContext.request.contextPath}/moderator/dashboard.jsp">Панель модератора</a>
    <a href="${pageContext.request.contextPath}/logout">Выход</a>
</div>

<div class="container">
    <h2>Панель модератора</h2>

    <p>Добро пожаловать, <b><%= user %></b>!</p>
    <p>Ваши роли: <b><%= roles %></b></p>

    <div class="dashboard-actions">
        <a href="${pageContext.request.contextPath}/moderator/books-manager.jsp" class="btn">
            📚 Управление книгами
        </a>
        <a href="${pageContext.request.contextPath}/moderator/add-book.jsp" class="btn">
            + Добавить книгу
        </a>
        <a href="${pageContext.request.contextPath}/books" class="btn">
            👁️ Просмотр каталога
        </a>
    </div>

    <p style="margin-top:30px;">
        <a href="${pageContext.request.contextPath}/">На главную</a>
    </p>
</div>

</body>
</html>