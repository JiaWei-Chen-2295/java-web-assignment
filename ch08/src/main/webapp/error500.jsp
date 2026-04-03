<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>500 - 服务器内部错误</title>
</head>
<body>
    <h2>500 - 服务器内部错误</h2>
    <%
        if (exception != null) {
    %>
    <p>错误类型：<%= exception.getClass().getName() %></p>
    <p>错误信息：<%= exception.getMessage() %></p>
    <%
        } else {
    %>
    <p>服务器发生了未知错误，请稍后再试。</p>
    <%
        }
    %>
    <p>此错误由 web.xml 中 &lt;error-code&gt; 500 配置捕获。</p>
</body>
</html>
