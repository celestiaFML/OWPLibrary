package com.example.portal.auth;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final Map<String, Set<String>> RULES = new LinkedHashMap<>();

    @Override
    public void init(FilterConfig cfg) {
        RULES.put("/admin/", set("admin"));
        RULES.put("/moderator/", set("moderator", "admin"));
        RULES.put("/user/", set("user", "moderator", "admin"));
        RULES.put("/upload", set("user", "moderator", "admin"));

        RULES.put("/moderator/add-book", set("moderator", "admin"));
        RULES.put("/moderator/edit-book", set("moderator", "admin"));
        RULES.put("/moderator/delete-book", set("moderator", "admin"));
        RULES.put("/moderator/books-manager.jsp", set("moderator", "admin"));
        RULES.put("/moderator/add-book.jsp", set("moderator", "admin"));
        RULES.put("/moderator/edit-book.jsp", set("moderator", "admin"));
    }

    private static Set<String> set(String... r) {
        return new HashSet<>(Arrays.asList(r));
    }

    @SuppressWarnings("unchecked")
    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) rq;
        HttpServletResponse resp = (HttpServletResponse) rs;

        String ctx = req.getContextPath();
        String uri = req.getRequestURI().substring(ctx.length());

        boolean isPublic =
                uri.equals("/") ||
                        uri.equals("/index.jsp") ||
                        uri.equals("/login") ||
                        uri.equals("/login.jsp") ||
                        uri.equals("/logout") ||
                        uri.equals("/hash.jsp") ||
                        uri.equals("/favicon.ico") ||
                        uri.startsWith("/assets/") ||
                        uri.startsWith("/css/") ||
                        uri.startsWith("/uploads/") ||
                        uri.equals("/books") ||
                        uri.equals("/book-list.jsp") ||
                        uri.equals("/book-detail.jsp") ||
                        uri.startsWith("/books?") ||
                        uri.endsWith(".css") ||
                        uri.endsWith(".js") ||
                        uri.endsWith(".jpg") ||
                        uri.endsWith(".jpeg") ||
                        uri.endsWith(".png") ||
                        uri.endsWith(".gif") ||
                        uri.endsWith(".ico");

        if (isPublic) {
            chain.doFilter(rq, rs);
            return;
        }

        for (Map.Entry<String, Set<String>> e : RULES.entrySet()) {
            if (uri.startsWith(e.getKey())) {
                HttpSession s = req.getSession(false);
                if (s == null) {
                    resp.sendRedirect(ctx + "/login.jsp");
                    return;
                }
                Object rolesObj = s.getAttribute("roles");
                if (!(rolesObj instanceof Set)) {
                    resp.sendRedirect(ctx + "/login.jsp");
                    return;
                }
                Set<String> roles = (Set<String>) rolesObj;
                for (String need : e.getValue()) {
                    if (roles.contains(need)) {
                        chain.doFilter(rq, rs);
                        return;
                    }
                }
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(rq, rs);
    }

    @Override
    public void destroy() {
        RULES.clear();
    }
}