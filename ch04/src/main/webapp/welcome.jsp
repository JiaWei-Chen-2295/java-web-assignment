<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录成功</title>
</head>
<body>
    <h2>登录成功！</h2>
    <p>欢迎您，<%= request.getAttribute("username") %></p>
    <p>登录时间：<%= request.getAttribute("loginTime") %></p>
    <p><a href="login.jsp">返回登录页面</a></p>
</body>
</html>
