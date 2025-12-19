package com.example.portal;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@MultipartConfig
public class UploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String ctx = req.getContextPath();

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(ctx + "/login.jsp");
            return;
        }
        String username = (String) s.getAttribute("user");

        Part avatar = req.getPart("avatar");
        if (avatar == null || avatar.getSize() == 0) {
            resp.sendRedirect(ctx + "/user/cabinet.jsp");
            return;
        }

        String submitted = Paths.get(avatar.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = submitted.lastIndexOf('.');
        if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

        File uploadDir = new File(getServletContext().getRealPath("/uploads"));
        if (!uploadDir.exists()) uploadDir.mkdirs();

        File dst = new File(uploadDir, username + ext);
        avatar.write(dst.getAbsolutePath());

        String relPath = "uploads/" + username + ext;
        s.setAttribute("avatarPath", relPath);

        resp.sendRedirect(ctx + "/user/cabinet.jsp");
    }
}