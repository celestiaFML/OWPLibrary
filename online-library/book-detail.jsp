<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.example.portal.model.News" %>
<%
    News news = (News) request.getAttribute("news");
    if (news == null) {
        response.sendRedirect(request.getContextPath() + "/news");
        return;
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= news.getTitle() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .news-detail {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .news-header {
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .news-title {
            color: #333;
            font-size: 2em;
            margin-bottom: 10px;
        }
        .news-meta {
            color: #666;
            font-size: 0.95em;
        }
        .news-category {
            display: inline-block;
            background: #e3f2fd;
            padding: 5px 12px;
            border-radius: 15px;
            color: #1976d2;
            font-weight: bold;
        }
        .news-content {
            line-height: 1.6;
            font-size: 1.1em;
            color: #444;
        }
        .news-content p {
            margin-bottom: 15px;
        }
        .back-link {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background: #f5f5f5;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
        }
        .back-link:hover {
            background: #e0e0e0;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/">Главная</a>
    <a href="${pageContext.request.contextPath}/news">Все новости</a>
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
    <div class="news-detail">
        <div class="news-header">
            <h1 class="news-title"><%= news.getTitle() %></h1>
            <div class="news-meta">
                <strong>Дата публикации:</strong> <%= news.getFormattedDate() %><br>
                <strong>Автор:</strong> <%= news.getAuthor() %><br>
                <% if (news.getCategory() != null && !news.getCategory().isEmpty()) { %>
                    <strong>Категория:</strong> <span class="news-category"><%= news.getCategory() %></span>
                <% } %>
            </div>
        </div>
        
        <div class="news-content">
            <%= news.getContent().replace("\n", "<br>") %>
        </div>
        
        <a class="back-link" href="${pageContext.request.contextPath}/news">
            ← Вернуться к списку новостей
        </a>
    </div>
</div>

</body>
</html>