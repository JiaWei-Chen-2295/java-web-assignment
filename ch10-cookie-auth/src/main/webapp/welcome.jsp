<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fun.auth.User" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>欢迎进入系统 - 免登录实验室</title>
    <style>
        :root {
            --primary: #6366f1;
            --bg: #f3f4f6;
            --card: #ffffff;
            --text: #111827;
        }
        body {
            font-family: 'Inter', system-ui, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: var(--card);
            padding: 3rem;
            border-radius: 1.5rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
            border: 1px solid rgba(255,255,255,0.7);
        }
        .icon {
            font-size: 3.5rem;
            margin-bottom: 1rem;
            display: block;
        }
        h1 { margin: 0 0 1rem; font-size: 1.875rem; font-weight: 800; color: #1f2937; }
        .user-info {
            background: #f9fafb;
            padding: 1.5rem;
            border-radius: 1rem;
            margin: 2rem 0;
            border: 1px solid #e5e7eb;
            text-align: left;
        }
        .info-row { display: flex; justify-content: space-between; margin: 0.5rem 0; }
        .label { color: #6b7280; font-size: 0.875rem; }
        .value { font-weight: 600; color: var(--primary); }
        .success-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background: #dcfce7;
            color: #166534;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 1rem;
        }
        .btn-logout {
            display: inline-block;
            margin-top: 1rem;
            color: #ef4444;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .btn-logout:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%
        User user = (User) request.getAttribute("user");
        if (user == null) {
            // Check session or direct cookie (fallback for welcome.jsp entry)
            // But since CookieAuthFilter handles it for all pages, user SHOULD be in attribute
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <div class="container">
        <span class="icon">✨</span>
        <h1>欢迎回来，<%= user.getName() %>!</h1>
        <p style="color: #4b5563;">您已成功登录系统</p>
        
        <div class="user-info">
            <div class="info-row">
                <span class="label">学号</span>
                <span class="value"><%= user.getStudentId() %></span>
            </div>
            <div class="info-row">
                <span class="label">姓名</span>
                <span class="value"><%= user.getName() %></span>
            </div>
            <div class="info-row">
                <span class="label">认证有效期</span>
                <span class="value">5分钟 (免登录)</span>
            </div>
        </div>

        <div class="success-badge">
            ✓ 免登录 Cookie 已生效
        </div>

        <div>
            <a href="login.jsp" class="btn-logout">退出登录</a>
        </div>
    </div>
</body>
</html>
