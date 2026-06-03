<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ch14-filter-intro</title>
    <link rel="stylesheet" href="css/claude-design.css">
</head>
<body class="theme-root">
<main class="container">
    <section class="panel">
        <h2>Filter 实验入口</h2>
        <p class="muted">Claude Design 主题 + 页面日志展示</p>
        <div class="link-list">
            <a href="login.jsp">用户登录（LoginValidatorFilter 验证码 + PermissionFilter 权限控制）</a>
            <a href="student">访问 StudentInfoServlet（WelcomeFilter）</a>
            <a href="circle">访问 CircleServlet（CircleFilter 生命周期）</a>
            <a href="register.html">进入注册页（EncodingFilter 中文编码）</a>
            <a href="register.jsp">用户注册（ResValidatorFilter 表单验证）</a>
        </div>
    </section>
</main>
</body>
</html>
