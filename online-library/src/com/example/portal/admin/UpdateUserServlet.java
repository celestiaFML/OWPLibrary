package com.example.portal.admin;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String[] newRoles = req.getParameterValues("roles");

        String usersJsonFile = getServletContext().getRealPath("/WEB-INF/users.json");
        ObjectMapper mapper = new ObjectMapper();
        File file = new File(usersJsonFile);
        JsonNode root = mapper.readTree(file);
        ArrayNode users = (ArrayNode) root.get("users");

        for (JsonNode user : users) {
            if (user.get("username").asText().equals(username)) {
                ArrayNode rolesNode = (ArrayNode) user.get("roles");
                rolesNode.removeAll();
                if (newRoles != null) {
                    for (String role : newRoles) {
                        rolesNode.add(role);
                    }
                }
                break;
            }
        }

        mapper.writerWithDefaultPrettyPrinter().writeValue(file, root);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
    }
}