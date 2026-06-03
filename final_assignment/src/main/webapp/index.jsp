<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 如果已登录，跳转到笔记列表；否则跳转到登录页
    if (session.getAttribute("currentUser") != null) {
        response.sendRedirect(request.getContextPath() + "/note/list");
    } else {
        response.sendRedirect(request.getContextPath() + "/user/login");
    }
%>
