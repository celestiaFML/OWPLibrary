<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.example.portal.model.Book" %>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/books");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= book.getTitle() %> - Онлайн Библиотека</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/books">Все книги</a>
    <%
        String user = (String) session.getAttribute("user");
        if (user != null) {
    %>
        <a href="${pageContext.request.contextPath}/user/cabinet.jsp">Кабинет</a>
        <a href="${pageContext.request.contextPath}/logout">Выход</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Вход</a>
    <% } %>
</div>

<div class="container">
    <h1><%= book.getTitle() %></h1>

    <div class="book-detail">
        <p><strong>Автор:</strong> <%= book.getAuthor() %></p>

        <% if (book.getGenre() != null && !book.getGenre().isEmpty()) { %>
            <p><strong>Жанр:</strong> <%= book.getGenre() %></p>
        <% } %>

        <% if (book.getIsbn() != null && !book.getIsbn().isEmpty()) { %>
            <p><strong>ISBN:</strong> <%= book.getIsbn() %></p>
        <% } %>

        <% if (book.getPageCount() > 0) { %>
            <p><strong>Количество страниц:</strong> <%= book.getPageCount() %></p>
        <% } %>

        <% if (book.getPublicationYear() > 0) { %>
            <p><strong>Год издания:</strong> <%= book.getPublicationYear() %></p>
        <% } %>

        <% if (book.getPublisher() != null && !book.getPublisher().isEmpty()) { %>
            <p><strong>Издательство:</strong> <%= book.getPublisher() %></p>
        <% } %>

        <p><strong>Описание:</strong></p>
        <div class="book-description">
            <%= book.getDescription() != null ? book.getDescription().replace("\n", "<br>") : "" %>
        </div>

        <p><strong>Статус:</strong>
            <span class="<%= book.isAvailable() ? "available" : "unavailable" %>">
                <%= book.isAvailable() ? "Доступна для выдачи" : "В настоящее время на руках" %>
            </span>
        </p>

        <p><strong>Дата добавления:</strong> <%= book.getFormattedDate() %></p>
    </div>

    <p style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/books">← Вернуться к каталогу</a>
    </p>
</div>

</body>
</html>