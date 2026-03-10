<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录页面</title>
</head>
<body>
    <h2>用户登录</h2>
    <form action="login" method="get">
        <label>
            账号： <input type="text" name="account" required>
        </label>
        <br><br>
        <label>
            密码： <input type="password" name="password" required>
        </label>
        <br><br>
        <input type="submit" value="登录">
    </form>
</body>
</html>
