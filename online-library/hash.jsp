<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
  String pw = request.getParameter("pw");
  if (pw == null || pw.isEmpty()) {
    out.println("Usage: /hash.jsp?pw=yourPassword");
  } else {
    String hash = BCrypt.hashpw(pw, BCrypt.gensalt(10));
    out.println(hash);
  }
%>