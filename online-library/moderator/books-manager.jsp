<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.example.portal.model.Book, java.util.List" %>
<%@ page import="com.example.portal.storage.BookStorage" %>
<%
    java.util.Set roles = (java.util.Set) session.getAttribute("roles");
    String user = (String) session.getAttribute("user");

    if (user == null || roles == null ||
        !(roles.contains("moderator") || roles.contains("admin"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookStorage storage = new BookStorage(application);
    List<Book> allBooks = storage.getAllBooks();
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Управление книгами</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/user/cabinet.jsp">Кабинет</a>
    <a href="${pageContext.request.contextPath}/moderator/books-manager.jsp">Управление книгами</a>
    <a href="${pageContext.request.contextPath}/logout">Выход</a>
</div>

<div class="container">
    <h2>Управление книгами</h2>

    <a href="${pageContext.request.contextPath}/moderator/add-book.jsp" class="btn" style="margin-bottom: 20px;">
        + Добавить книгу
    </a>

    <% if (allBooks.isEmpty()) { %>
        <p>Нет книг для отображения.</p>
    <% } else { %>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Название</th>
                    <th>Автор</th>
                    <th>Жанр</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <% for (Book book : allBooks) { %>
                    <tr>
                        <td><%= book.getId() %></td>
                        <td><%= book.getTitle() %></td>
                        <td><%= book.getAuthor() %></td>
                        <td><%= book.getGenre() != null ? book.getGenre() : "—" %></td>
                        <td>
                            <% if (book.isAvailable()) { %>
                                <span class="available">Доступна</span>
                            <% } else { %>
                                <span class="unavailable">На руках</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/moderator/edit-book?id=<%= book.getId() %>"
                               class="btn" style="padding: 5px 10px;">Редактировать</a>
                            <form method="post" action="${pageContext.request.contextPath}/moderator/delete-book"
                                  style="display: inline;">
                                <input type="hidden" name="id" value="<%= book.getId() %>">
                                <button type="submit" class="btn"
                                        style="padding: 5px 10px; background: #dc3545;"
                                        onclick="return confirm('Удалить книгу?')">
                                    Удалить
                                </button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>

    <p style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/">На главную</a>
    </p>
</div>

</body>
</html>