<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<% request.setCharacterEncoding("UTF-8"); %>

<%@ page import="com.example.portal.model.News, java.util.List" %>
<%@ page import="com.example.portal.storage.NewsStorage" %>
<%
    // Проверка прав
    java.util.Set roles = (java.util.Set) session.getAttribute("roles");
    String user = (String) session.getAttribute("user");
    
    if (user == null || roles == null || 
        !(roles.contains("moderator") || roles.contains("admin"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Получаем новость для редактирования
    News news = (News) request.getAttribute("news");
    if (news == null) {
        // Если новость не передана, пробуем получить по ID из параметра
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                NewsStorage storage = new NewsStorage(application);
                news = storage.getNewsById(id);
                
                // Дополнительная проверка прав: можно редактировать только свои новости или если админ
                if (news != null) {
                    if (!user.equals(news.getAuthor()) && !roles.contains("admin")) {
                        response.sendRedirect(request.getContextPath() + "/moderator/news-manager.jsp");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        
        if (news == null) {
            response.sendRedirect(request.getContextPath() + "/moderator/news-manager.jsp");
            return;
        }
    }
    
    // Получаем список категорий
    NewsStorage storage = new NewsStorage(application);
    List<String> categories = storage.getCategories();
    
    String error = (String) request.getAttribute("error");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Редактирование новости</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .edit-form {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }
        textarea.form-control {
            min-height: 200px;
            resize: vertical;
            font-family: Arial, sans-serif;
            line-height: 1.5;
        }
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background: #4a90e2;
            color: white;
        }
        .btn-primary:hover {
            background: #3a7bc8;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .status-options {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        .status-options label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        .status-options input[type="radio"] {
            width: auto;
        }
        .info-note {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #4a90e2;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/user/cabinet.jsp">Кабинет</a>
    <a href="${pageContext.request.contextPath}/moderator/news-manager.jsp">Управление новостями</a>
    <a href="${pageContext.request.contextPath}/logout">Выход</a>
</div>

<div class="container">
    <h2>Редактирование новости</h2>
    
    <% if (error != null) { %>
        <div class="error-message">
            <%= error %>
        </div>
    <% } %>
    
    <% if (roles.contains("admin")) { %>
        <div class="info-note">
            <strong>Примечание для администратора:</strong> Вы можете редактировать любую новость, включая изменение статуса.
        </div>
    <% } else if (user.equals(news.getAuthor())) { %>
        <div class="info-note">
            <strong>Примечание:</strong> Вы редактируете свою собственную новость.
        </div>
    <% } %>
    
    <form method="post" action="${pageContext.request.contextPath}/moderator/edit-news" 
          class="edit-form" accept-charset="UTF-8">
        <input type="hidden" name="id" value="<%= news.getId() %>">
        
        <div class="form-group">
            <label for="title">Заголовок новости *</label>
            <input type="text" id="title" name="title" class="form-control" 
                   value="<%= news.getTitle() %>" required>
        </div>
        
        <div class="form-group">
            <label for="content">Содержание новости *</label>
            <textarea id="content" name="content" class="form-control" 
                      required><%= news.getContent() %></textarea>
        </div>
        
        <div class="form-group">
            <label for="category">Категория</label>
            <input type="text" id="category" name="category" class="form-control" 
                   value="<%= news.getCategory() != null ? news.getCategory() : "" %>"
                   list="category-list">
            <datalist id="category-list">
                <% for (String category : categories) { %>
                    <option value="<%= category %>">
                <% } %>
            </datalist>
            <small style="color: #666;">Можно выбрать из списка или ввести новую</small>
        </div>
        
        <% if (roles.contains("admin")) { %>
            <div class="form-group">
                <label>Статус новости</label>
                <div class="status-options">
                    <label>
                        <input type="radio" name="status" value="draft" 
                               <%= "draft".equals(news.getStatus()) ? "checked" : "" %>>
                        Черновик
                    </label>
                    <label>
                        <input type="radio" name="status" value="published" 
                               <%= "published".equals(news.getStatus()) ? "checked" : "" %>>
                        Опубликовано
                    </label>
                    <label>
                        <input type="radio" name="status" value="archived" 
                               <%= "archived".equals(news.getStatus()) ? "checked" : "" %>>
                        Архив
                    </label>
                </div>
            </div>
        <% } else { %>
            <input type="hidden" name="status" value="<%= news.getStatus() %>">
        <% } %>
        
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/moderator/news-manager.jsp" 
               class="btn btn-secondary">
                ← Назад к списку
            </a>
            <button type="submit" class="btn btn-primary">
                Сохранить изменения
            </button>
        </div>
        
        <div style="margin-top: 20px; color: #666; font-size: 0.9em;">
            <p><strong>Информация о новости:</strong></p>
            <p>ID: <%= news.getId() %></p>
            <p>Автор: <%= news.getAuthor() %></p>
            <p>Дата создания: <%= news.getFormattedDate() %></p>
            <p>Текущий статус: 
                <% 
                    String statusText = "";
                    switch(news.getStatus()) {
                        case "draft": statusText = "Черновик"; break;
                        case "published": statusText = "Опубликовано"; break;
                        case "archived": statusText = "Архив"; break;
                        default: statusText = news.getStatus();
                    }
                %>
                <strong><%= statusText %></strong>
            </p>
        </div>
    </form>
    
    <p style="margin-top: 20px; text-align: center;">
        <a href="${pageContext.request.contextPath}/">На главную</a>
    </p>
</div>

<script>
    // Автоматическое фокусирование на поле заголовка
    document.getElementById('title').focus();
    
    // Подсчет символов в содержании
    const contentTextarea = document.getElementById('content');
    const charCount = document.createElement('div');
    charCount.style.cssText = 'color: #666; font-size: 0.9em; text-align: right; margin-top: 5px;';
    contentTextarea.parentNode.appendChild(charCount);
    
    function updateCharCount() {
        const length = contentTextarea.value.length;
        charCount.textContent = length + ' символов';
        
        if (length < 100) {
            charCount.style.color = '#dc3545';
        } else if (length < 500) {
            charCount.style.color = '#ffc107';
        } else {
            charCount.style.color = '#28a745';
        }
    }
    
    contentTextarea.addEventListener('input', updateCharCount);
    updateCharCount(); // Инициализация
    
    // Проверка формы перед отправкой
    document.querySelector('form').addEventListener('submit', function(e) {
        const title = document.getElementById('title').value.trim();
        const content = document.getElementById('content').value.trim();
        
        if (!title) {
            e.preventDefault();
            alert('Пожалуйста, введите заголовок новости');
            document.getElementById('title').focus();
            return;
        }
        
        if (!content) {
            e.preventDefault();
            alert('Пожалуйста, введите содержание новости');
            document.getElementById('content').focus();
            return;
        }
        
        if (content.length < 50) {
            if (!confirm('Содержание новости очень короткое (менее 50 символов). Вы уверены, что хотите сохранить?')) {
                e.preventDefault();
                return;
            }
        }
    });
</script>

</body>
</html>