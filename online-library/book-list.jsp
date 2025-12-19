<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.example.portal.model.Book, java.util.List" %>
<%@ page import="com.example.portal.storage.BookStorage" %>
<%
    BookStorage storage = new BookStorage(application);
    List<Book> books = storage.getAllBooks();
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Каталог книг - Онлайн Библиотека</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/books">Каталог книг</a>
    <%
        java.util.Set roles = (java.util.Set) session.getAttribute("roles");
        String user = (String) session.getAttribute("user");

        if (user != null) {
    %>
        <a href="${pageContext.request.contextPath}/user/cabinet.jsp">Кабинет</a>
        <% if (roles != null && (roles.contains("moderator") || roles.contains("admin"))) { %>
            <a href="${pageContext.request.contextPath}/moderator/books-manager.jsp">Управление книгами</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout">Выход</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Вход</a>
    <% } %>
</div>

<div class="container">
    <h1>Каталог книг</h1>

    <% if (books.isEmpty()) { %>
        <p>Книг пока нет в библиотеке.</p>
    <% } else { %>
        <div class="books-list">
            <% for (Book book : books) { %>
                <div class="book-card">
                    <div class="book-info">
                        <h3><a href="${pageContext.request.contextPath}/books?id=<%= book.getId() %>"><%= book.getTitle() %></a></h3>
                        <p class="author"><strong>Автор:</strong> <%= book.getAuthor() %></p>
                        <% if (book.getGenre() != null && !book.getGenre().isEmpty()) { %>
                            <p class="genre"><strong>Жанр:</strong> <%= book.getGenre() %></p>
                        <% } %>
                        <p class="description"><%= book.getShortDescription() %></p>
                        <p class="status <%= book.isAvailable() ? "available" : "unavailable" %>">
                            <%= book.isAvailable() ? "Доступна" : "На руках" %>
                        </p>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>

    <p style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/">На главную</a>
    </p>
</div>

</body>
</html>