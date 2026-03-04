<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>ch01 - first.jsp</title>
</head>
<body>
    <div class="container">
        <h1>Hello, 2026!</h1>

        <p>学号姓名：<span class="info">2023154202 陈佳玮</span></p>

        <p>当前日期和时间：<span class="info">
            <%= LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss")) %>
        </span></p>

        <p>我是数据科学与大数据技术2023154202陈佳玮</p>
    </div>
</body>
</html>
