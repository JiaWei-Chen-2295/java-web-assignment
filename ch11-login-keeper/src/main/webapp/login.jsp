<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - LoginKeeper</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .login-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 64px - 80px);
            padding: 32px 16px;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
        }
        .login-card .card-body {
            padding: 40px 36px 32px;
        }
        .login-logo {
            text-align: center;
            margin-bottom: 8px;
        }
        .login-logo .icon {
            width: 56px;
            height: 56px;
            background: var(--primary);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: #fff;
            margin-bottom: 16px;
        }
        .login-title {
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 4px;
        }
        .login-subtitle {
            text-align: center;
            font-size: 14px;
            color: var(--gray-600);
            margin-bottom: 28px;
        }
        .remember-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            font-size: 13px;
        }
        .remember-row label {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--gray-700);
            cursor: pointer;
            font-weight: 400;
            margin-bottom: 0;
        }
        .cookie-hint {
            margin-top: 24px;
            padding: 14px 16px;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius);
            font-size: 13px;
            color: var(--gray-600);
        }
        .cookie-hint strong {
            color: var(--gray-800);
        }
        .cookie-hint ul {
            margin: 8px 0 0 16px;
            padding: 0;
        }
        .cookie-hint li {
            margin-bottom: 2px;
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
            <li><a href="login.jsp" class="active">登录</a></li>
            <li><a href="register">注册</a></li>
        </ul>
    </nav>

    <div class="login-wrapper">
        <div class="login-card card">
            <div class="card-body">
                <div class="login-logo">
                    <div class="icon">&#x1F512;</div>
                </div>
                <h1 class="login-title">欢迎回来</h1>
                <p class="login-subtitle">登录您的账户以继续</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <span>&#x26A0;</span>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <% if (request.getParameter("registered") != null) { %>
                <div class="alert alert-success">
                    <span>&#x2713;</span>
                    注册成功！请登录。
                </div>
                <% } %>

                <form action="login" method="post">
                    <div class="form-group">
                        <label for="username">用户名</label>
                        <input type="text" id="username" name="username" placeholder="请输入用户名" required>
                    </div>
                    <div class="form-group">
                        <label for="password">密码</label>
                        <input type="password" id="password" name="password" placeholder="请输入密码" required>
                    </div>
                    <div class="remember-row">
                        <label>
                            <input type="checkbox" name="remember"> 记住我
                        </label>
                        <a href="#" class="link" style="font-size:13px;">忘记密码？</a>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">登 录</button>
                </form>

                <div class="form-footer">
                    还没有账户？<a href="register" class="link">立即注册</a>
                </div>

                <div class="cookie-hint">
                    <strong>Cookie 配置</strong>
                    <ul>
                        <li><strong>名称：</strong>userLogin</li>
                        <li><strong>有效期：</strong>5 分钟（300 秒）</li>
                        <li><strong>路径：</strong>/</li>
                    </ul>
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
