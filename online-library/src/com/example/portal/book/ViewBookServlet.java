package com.example.portal.book;

import com.example.portal.model.Book;
import com.example.portal.storage.BookStorage;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ViewBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) {
            BookStorage storage = new BookStorage(getServletContext());
            req.setAttribute("books", storage.getAllBooks());
            req.getRequestDispatcher("/book-list.jsp").forward(req, resp);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            BookStorage storage = new BookStorage(getServletContext());
            Book book = storage.getBookById(id);

            if (book == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            req.setAttribute("book", book);
            req.getRequestDispatcher("/book-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}