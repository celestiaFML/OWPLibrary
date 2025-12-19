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

    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                BookStorage storage = new BookStorage(application);
                book = storage.getBookById(id);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/moderator/books-manager.jsp");
            return;
        }
    }

    BookStorage storage = new BookStorage(application);
    List<String> genres = storage.getGenres();
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Редактирование книги</title>
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
    <h2>Редактирование книги</h2>

    <form method="post" action="${pageContext.request.contextPath}/moderator/edit-book">
        <input type="hidden" name="id" value="<%= book.getId() %>">

        <div class="form-group">
            <label for="title">Название книги *</label>
            <input type="text" id="title" name="title" class="form-control"
                   value="<%= book.getTitle() %>" required>
        </div>

        <div class="form-group">
            <label for="author">Автор *</label>
            <input type="text" id="author" name="author" class="form-control"
                   value="<%= book.getAuthor() %>" required>
        </div>

        <div class="form-group">
            <label for="description">Описание</label>
            <textarea id="description" name="description" class="form-control" rows="5"><%= book.getDescription() != null ? book.getDescription() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="genre">Жанр</label>
            <input type="text" id="genre" name="genre" class="form-control"
                   value="<%= book.getGenre() != null ? book.getGenre() : "" %>"
                   list="genre-list">
            <datalist id="genre-list">
                <% for (String genre : genres) { %>
                    <option value="<%= genre %>">
                <% } %>
            </datalist>
        </div>

        <div class="form-group">
            <label for="isbn">ISBN</label>
            <input type="text" id="isbn" name="isbn" class="form-control"
                   value="<%= book.getIsbn() != null ? book.getIsbn() : "" %>">
        </div>

        <div class="form-group">
            <label for="pageCount">Количество страниц</label>
            <input type="number" id="pageCount" name="pageCount" class="form-control"
                   value="<%= book.getPageCount() > 0 ? book.getPageCount() : "" %>">
        </div>

        <div class="form-group">
            <label for="publicationYear">Год издания</label>
            <input type="number" id="publicationYear" name="publicationYear" class="form-control"
                   value="<%= book.getPublicationYear() > 0 ? book.getPublicationYear() : "" %>">
        </div>

        <div class="form-group">
            <label for="publisher">Издательство</label>
            <input type="text" id="publisher" name="publisher" class="form-control"
                   value="<%= book.getPublisher() != null ? book.getPublisher() : "" %>">
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="available" <%= book.isAvailable() ? "checked" : "" %>>
                Доступна для выдачи
            </label>
        </div>

        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/moderator/books-manager.jsp" class="btn">Отмена</a>
            <button type="submit" class="btn btn-primary">Сохранить изменения</button>
        </div>
    </form>

    <p style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/">На главную</a>
    </p>
</div>

</body>
</html>