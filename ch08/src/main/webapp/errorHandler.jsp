<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>错误处理页面</title>
</head>
<body>
    <h2>发生了错误！</h2>
    <p>错误类型：<%= exception.getClass().getName() %></p>
    <p>错误信息：<%= exception.getMessage() %></p>
</body>
</html>
