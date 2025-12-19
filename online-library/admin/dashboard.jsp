<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper, com.fasterxml.jackson.databind.JsonNode" %>
<%@ page import="java.io.File, java.util.*" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Панель администратора</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/">Главная</a>
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Панель администратора</a>
        <a href="${pageContext.request.contextPath}/logout">Выход</a>
    </div>

    <div class="container">
        <h2>Панель администратора</h2>
        <h3>Список пользователей</h3>

        <% 
        String usersJsonFile = getServletContext().getRealPath("/WEB-INF/users.json");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode users = mapper.readTree(new File(usersJsonFile)).get("users");

        for (JsonNode user : users) {
            String username = user.get("username").asText();
            String roles = user.get("roles").toString();
        %>

        <div class="user-info">
            <p>Имя пользователя: <b><%= username %></b></p>
            <p>Роли: <b><%= roles %></b></p>
            <a href="<%= request.getContextPath() %>/admin/editUser.jsp?username=<%= username %>">Редактировать</a>
        </div>

        <% } %>

        <p><a href="${pageContext.request.contextPath}/">На главную</a></p>
    </div>
</body>
</html>