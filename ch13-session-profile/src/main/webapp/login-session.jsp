<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 已登录则跳转
    if (session.getAttribute("loginUser") != null) {
        response.sendRedirect("profile.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
    String savedUsername = (String) request.getAttribute("username");
    if (savedUsername == null) savedUsername = "";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 — Session Profile</title>
    <style>
        :root {
            --apple-blue: #007AFF;
            --apple-blue-hover: #0063D1;
            --apple-gray: #86868B;
            --apple-bg: #F5F5F7;
            --apple-surface: #FFFFFF;
            --apple-text: #1D1D1F;
            --apple-text-secondary: #6E6E73;
            --apple-radius: 18px;
            --apple-radius-sm: 12px;
            --apple-shadow: 0 2px 12px rgba(0,0,0,0.08);
            --apple-shadow-lg: 0 8px 40px rgba(0,0,0,0.12);
            --apple-font: -apple-system, BlinkMacSystemFont, 'SF Pro Display',
                          'SF Pro Text', 'Helvetica Neue', 'Microsoft YaHei', sans-serif;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--apple-font);
            background: var(--apple-bg);
            color: var(--apple-text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Hero */
        .login-hero {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 40%, #0f3460 100%);
            padding: 120px 40px 80px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .login-hero::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(ellipse at 30% 50%, rgba(0,122,255,0.15) 0%, transparent 60%);
            pointer-events: none;
        }
        .login-hero h1 {
            font-size: 48px;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -1.5px;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }
        .login-hero p {
            font-size: 19px;
            color: rgba(255,255,255,0.7);
            font-weight: 400;
            letter-spacing: -0.2px;
            position: relative;
            z-index: 1;
        }

        /* Card */
        .login-wrapper {
            flex: 1;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 40px 20px 80px;
            margin-top: -40px;
            position: relative;
            z-index: 2;
        }
        .login-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow-lg);
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
            animation: fadeUp 0.6s ease-out;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .login-card h2 {
            font-size: 28px;
            font-weight: 600;
            text-align: center;
            letter-spacing: -0.5px;
            margin-bottom: 32px;
        }

        /* Error */
        .error-msg {
            background: #FFF0F0;
            color: #D70015;
            font-size: 14px;
            padding: 12px 16px;
            border-radius: var(--apple-radius-sm);
            margin-bottom: 20px;
            text-align: center;
        }

        /* Form */
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--apple-text-secondary);
            margin-bottom: 6px;
        }
        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            height: 48px;
            padding: 0 16px;
            font-size: 16px;
            font-family: var(--apple-font);
            color: var(--apple-text);
            background: var(--apple-bg);
            border: 1.5px solid transparent;
            border-radius: var(--apple-radius-sm);
            outline: none;
            transition: all 0.2s ease;
        }
        .form-group input:focus {
            border-color: var(--apple-blue);
            background: var(--apple-surface);
            box-shadow: 0 0 0 4px rgba(0,122,255,0.1);
        }
        .form-group input::placeholder {
            color: #C7C7CC;
        }

        /* Captcha Row */
        .captcha-row {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .captcha-row input {
            flex: 1;
        }
        .captcha-img {
            height: 48px;
            width: 120px;
            border-radius: var(--apple-radius-sm);
            cursor: pointer;
            border: 1.5px solid var(--apple-bg);
            transition: border-color 0.2s;
        }
        .captcha-img:hover {
            border-color: var(--apple-blue);
        }

        /* Submit */
        .btn-submit {
            width: 100%;
            height: 50px;
            font-size: 17px;
            font-weight: 500;
            font-family: var(--apple-font);
            color: #FFFFFF;
            background: var(--apple-blue);
            border: none;
            border-radius: 980px;
            cursor: pointer;
            transition: background 0.2s ease;
            margin-top: 8px;
        }
        .btn-submit:hover {
            background: var(--apple-blue-hover);
        }
        .btn-submit:active {
            transform: scale(0.98);
        }

        /* Footer link */
        .login-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 13px;
            color: var(--apple-text-secondary);
        }
        .login-footer a {
            color: var(--apple-blue);
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }

        /* Tips */
        .login-tips {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid var(--apple-bg);
            font-size: 12px;
            color: var(--apple-gray);
            text-align: center;
            line-height: 1.8;
        }
    </style>
</head>
<body>

<div class="login-hero">
    <h1>欢迎回来</h1>
    <p>登录以访问你的个人空间</p>
</div>

<div class="login-wrapper">
    <div class="login-card">
        <h2>账号登录</h2>

        <% if (error != null) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="<%= ctx %>/doLogin" method="post" autocomplete="off">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" placeholder="请输入用户名"
                       value="<%= savedUsername %>" required autofocus>
            </div>

            <div class="form-group">
                <label>密码</label>
                <input type="password" name="password" placeholder="请输入密码" required>
            </div>

            <div class="form-group">
                <label>验证码</label>
                <div class="captcha-row">
                    <input type="text" name="captcha" placeholder="输入验证码"
                           maxlength="4" required style="flex:1;">
                    <img src="<%= ctx %>/captcha" alt="验证码" class="captcha-img"
                         id="captchaImg" title="点击刷新验证码"
                         onclick="this.src='<%= ctx %>/captcha?t='+Date.now()">
                </div>
            </div>

            <button type="submit" class="btn-submit">登录</button>
        </form>

        <div class="login-tips">
            测试账号：admin / 123456<br>
            javierchen / hello &nbsp;|&nbsp; demo / demo
        </div>
    </div>
</div>

</body>
</html>
