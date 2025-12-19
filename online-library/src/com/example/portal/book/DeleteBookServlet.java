package com.example.portal.book;

import com.example.portal.storage.BookStorage;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class DeleteBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

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

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/moderator/books-manager.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            BookStorage storage = new BookStorage(getServletContext());
            storage.deleteBook(id);
        } catch (NumberFormatException e) {
            // ignore
        }

        resp.sendRedirect(req.getContextPath() + "/moderator/books-manager.jsp");
    }
}