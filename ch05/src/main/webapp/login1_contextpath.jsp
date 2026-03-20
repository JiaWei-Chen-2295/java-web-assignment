<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - ContextPath绝对路径</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f5f5f5; }
        .login-form { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #333; margin-bottom: 10px; }
        .path-type { text-align: center; color: #2196F3; font-size: 12px; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background-color: #2196F3; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #1976D2; }
        .code { background: #f5f5f5; padding: 8px; border-radius: 4px; font-family: monospace; font-size: 12px; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="login-form">
        <h2>用户登录</h2>
        <div class="path-type">方式1: ContextPath绝对路径</div>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="account">账号</label>
                <input type="text" id="account" name="account" required placeholder="学号+名字">
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">登录</button>
        </form>
        <div class="code">action="${pageContext.request.contextPath}/login"</div>
    </div>
</body>
</html>
