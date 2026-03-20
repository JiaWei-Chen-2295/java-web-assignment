<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户登录</title>
</head>
<body>
    <h2>用户登录</h2>
    <form action="login" method="post">
        <p>
            用户名(学号+姓名)：<input type="text" name="username" placeholder="如：2023154202陈佳玮">
        </p>
        <p>
            密码：<input type="password" name="password">
        </p>
        <p>
            <input type="submit" value="登录">
        </p>
    </form>
</body>
</html>
