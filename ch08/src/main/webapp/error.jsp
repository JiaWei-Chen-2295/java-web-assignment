<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="errorHandler.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>除法运算</title>
</head>
<body>
    <h2>除法运算示例</h2>
    <%
        int a = 10;
        int b = 0;
        // b 为 0，将触发 ArithmeticException
        int result = a / b;
    %>
    <p>计算结果：<%= result %></p>
</body>
</html>
