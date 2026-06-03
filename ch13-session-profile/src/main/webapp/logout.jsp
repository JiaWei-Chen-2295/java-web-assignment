<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 销毁 session 并重定向到登录页
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("login-session.jsp");
%>
