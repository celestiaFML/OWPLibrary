package com.example.portal.auth;

import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.node.ArrayNode;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    static class UserRec {
        public String username;
        public String passwordHash;
        public List<String> roles;
    }

    private List<UserRec> loadUsers(ServletContext ctx) throws IOException {
        try (InputStream is = ctx.getResourceAsStream("/WEB-INF/users.json")) {
            if (is == null) throw new IOException("WEB-INF/users.json not found");
            ObjectMapper om = new ObjectMapper();
            JsonNode root = om.readTree(is);
            ArrayNode arr = (ArrayNode) root.get("users");
            List<UserRec> out = new ArrayList<>();
            for (JsonNode n : arr) {
                UserRec u = new UserRec();
                u.username = n.get("username").asText();
                u.passwordHash = n.get("passwordHash").asText();
                u.roles = new ArrayList<>();
                for (JsonNode r : (ArrayNode) n.get("roles")) u.roles.add(r.asText());
                out.add(u);
            }
            return out;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Optional<UserRec> u = loadUsers(getServletContext()).stream()
                .filter(x -> x.username.equals(username)).findFirst();

        if (u.isPresent() && BCrypt.checkpw(password, u.get().passwordHash)) {
            HttpSession s = req.getSession(true);
            s.setAttribute("user", u.get().username);
            s.setAttribute("roles", new HashSet<>(u.get().roles));
            resp.sendRedirect(req.getContextPath() + "/user/cabinet.jsp");
        } else {
            req.setAttribute("error", "Неверные имя пользователя или пароль");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}