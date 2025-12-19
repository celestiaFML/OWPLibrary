<%@ page contentType="text/html; charset=UTF-8" %>
<%
  java.util.Set roles = (java.util.Set) session.getAttribute("roles");
  String user = (String) session.getAttribute("user");

  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  String roleLabel = "пользователь";
  if (roles != null) {
    if (roles.contains("admin")) roleLabel = "администратор";
    else if (roles.contains("moderator")) roleLabel = "модератор";
  }

  String avatar = (String) session.getAttribute("avatarPath");
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Личный кабинет</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

  <div class="navbar">
    <a href="<%= request.getContextPath() %>/">Главная</a>
    <a href="<%= request.getContextPath() %>/user/cabinet.jsp">Кабинет</a>
    <% if (roles != null && (roles.contains("moderator") || roles.contains("admin"))) { %>
        <a href="<%= request.getContextPath() %>/moderator/dashboard.jsp">Панель модератора</a>
    <% } %>
    <a href="<%= request.getContextPath() %>/logout">Выход</a>
  </div>

  <div class="container">
    <h2>Личный кабинет</h2>

    <p>Вы вошли как: <b><%= user %></b></p>
    <p>Ваша роль: <b><%= roleLabel %></b></p>

    <% if (avatar != null) { %>
      <p>Текущий аватар:</p>
      <img class="avatar" src="<%= request.getContextPath() + "/" + avatar %>" alt="Аватар">
    <% } %>

    <h3>Загрузить аватар</h3>
    <form method="post" action="<%= request.getContextPath() %>/upload" enctype="multipart/form-data