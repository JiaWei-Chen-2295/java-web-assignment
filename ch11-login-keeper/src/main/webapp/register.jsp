<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - LoginKeeper</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .register-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 64px - 80px);
            padding: 32px 16px;
        }
        .register-card {
            width: 100%;
            max-width: 420px;
        }
        .register-card .card-body {
            padding: 40px 36px 32px;
        }
        .register-logo {
            text-align: center;
            margin-bottom: 8px;
        }
        .register-logo .icon {
            width: 56px;
            height: 56px;
            background: var(--success);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: #fff;
            margin-bottom: 16px;
        }
        .register-title {
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 4px;
        }
        .register-subtitle {
            text-align: center;
            font-size: 14px;
            color: var(--gray-600);
            margin-bottom: 28px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="login.jsp" class="navbar-brand">
            <span class="logo">L</span>
            LoginKeeper
        </a>
        <ul class="navbar-nav">
            <li><a href="login.jsp">登录</a></li>
            <li><a href="register" class="active">注册</a></li>
        </ul>
    </nav>

    <div class="register-wrapper">
        <div class="register-card card">
            <div class="card-body">
                <div class="register-logo">
                    <div class="icon">&#x1F464;</div>
                </div>
                <h1 class="register-title">创建账户</h1>
                <p class="register-subtitle">填写以下信息以开始使用</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <span>&#x26A0;</span>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <form action="register" method="post">
                    <div class="form-group">
                        <label for="username">用户名</label>
                        <input type="text" id="username" name="username" placeholder="请输入用户名" required>
                    </div>
                    <div class="form-group">
                        <label for="password">密码</label>
                        <input type="password" id="password" name="password" placeholder="请设置密码" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">确认密码</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">注 册</button>
                </form>

                <div class="form-footer">
                    已有账户？<a href="login.jsp" class="link">立即登录</a>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 LoginKeeper &middot; Cookie 会话演示
    </footer>

    <%@ include file="/WEB-INF/jspf/debug-panel.jspf" %>
</body>
</html>
