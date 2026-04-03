<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>算术运算错误</title>
</head>
<body>
    <h2>发生了算术运算错误（ArithmeticException）</h2>
    <p>错误类型：<%= exception.getClass().getName() %></p>
    <p>错误信息：<%= exception.getMessage() %></p>
    <p>此错误由 web.xml 中 &lt;exception-type&gt; 配置捕获。</p>
</body>
</html>
