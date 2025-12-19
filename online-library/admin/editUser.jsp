<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper, com.fasterxml.jackson.databind.JsonNode" %>
<%@ page import="java.io.File, java.util.*" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Редактирование пользователя</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/">Главная</a>
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Панель администратора</a>
        <a href="${pageContext.request.contextPath}/logout">Выход</a>
    </div>

    <div class="container">
        <h2>Редактирование пользователя</h2>

        <% 
        String username = request.getParameter("username");
        String usersJsonFile = getServletContext().getRealPath("/WEB-INF/users.json");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode users = mapper.readTree(new File(usersJsonFile)).get("users");

        JsonNode userToEdit = null;
        for (JsonNode user : users) {
            if (user.get("username").asText().equals(username)) {
                userToEdit = user;
                break;
            }
        }

        if (userToEdit != null) {
            Set<String> currentRoles = new HashSet<>();
            for (JsonNode role : userToEdit.get("roles")) {
                currentRoles.add(role.asText());
            }
        %>

        <form method="post" action="<%= request.getContextPath() %>/admin/updateUser">
            <label>Имя пользователя: <b><%= userToEdit.get("username").asText() %></b></label><br>

            <label>Роли:</label><br>
            <label><input type="checkbox" name="roles" value="user" <%= currentRoles.contains("user") ? "checked" : "" %>> Пользователь</label><br>
            <label><input type="checkbox" name="roles" value="moderator" <%= currentRoles.contains("moderator") ? "checked" : "" %>> Модератор</label><br>
            <label><input type="checkbox" name="roles" value="admin" <%= currentRoles.contains("admin") ? "checked" : "" %>> Администратор</label><br><br>

            <input type="hidden" name="username" value="<%= username %>">
            <button type="submit">Сохранить изменения</button>
        </form>

        <% } else { %>
            <p>Пользователь не найден.</p>
        <% } %>

        <p><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Вернуться к панели администратора</a></p>
    </div>
</body>
</html>