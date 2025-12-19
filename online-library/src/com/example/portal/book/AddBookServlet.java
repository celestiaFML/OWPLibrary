package com.example.portal.book;

import com.example.portal.model.Book;
import com.example.portal.storage.BookStorage;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AddBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        java.util.Set<String> roles = (java.util.Set<String>) session.getAttribute("roles");
        if (roles == null || !(roles.contains("moderator") || roles.contains("admin"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        BookStorage storage = new BookStorage(getServletContext());
        req.setAttribute("genres", storage.getGenres());
        req.getRequestDispatcher("/moderator/add-book.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        java.util.Set<String> roles = (java.util.Set<String>) session.getAttribute("roles");
        if (roles == null || !(roles.contains("moderator") || roles.contains("admin"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String description = req.getParameter("description");
        String genre = req.getParameter("genre");
        String isbn = req.getParameter("isbn");
        String pageCountStr = req.getParameter("pageCount");
        String publicationYearStr = req.getParameter("publicationYear");
        String publisher = req.getParameter("publisher");

        if (title == null || title.trim().isEmpty() ||
                author == null || author.trim().isEmpty()) {
            req.setAttribute("error", "Название и автор книги обязательны");
            req.getRequestDispatcher("/moderator/add-book.jsp").forward(req, resp);
            return;
        }

        Book book = new Book();
        book.setTitle(title.trim());
        book.setAuthor(author.trim());
        book.setDescription(description != null ? description.trim() : "");
        book.setGenre(genre != null ? genre.trim() : "");
        book.setIsbn(isbn != null ? isbn.trim() : "");
        book.setPublisher(publisher != null ? publisher.trim() : "");

        try {
            if (pageCountStr != null && !pageCountStr.trim().isEmpty()) {
                book.setPageCount(Integer.parseInt(pageCountStr));
            }
            if (publicationYearStr != null && !publicationYearStr.trim().isEmpty()) {
                book.setPublicationYear(Integer.parseInt(publicationYearStr));
            }
        } catch (NumberFormatException e) {
            // ignore
        }

        BookStorage storage = new BookStorage(getServletContext());
        storage.addBook(book);

        resp.sendRedirect(req.getContextPath() + "/moderator/books-manager.jsp");
    }
}