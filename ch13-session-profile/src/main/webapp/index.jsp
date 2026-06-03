<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser != null) {
        response.sendRedirect("profile.jsp");
    } else {
        response.sendRedirect("login-session.jsp");
    }
%>
