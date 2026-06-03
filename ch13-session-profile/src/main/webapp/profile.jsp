<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login-session.jsp");
        return;
    }
    String loginTime = (String) session.getAttribute("loginTime");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人资料 — Session Profile</title>
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
            padding-top: 52px;
            min-height: 100vh;
        }

        /* Hero */
        .profile-hero {
            background: linear-gradient(135deg, #f5f5f7 0%, #e8e8ed 100%);
            padding: 60px 40px 40px;
            text-align: center;
        }
        .profile-hero h1 {
            font-size: 40px;
            font-weight: 700;
            letter-spacing: -1px;
            color: var(--apple-text);
        }
        .profile-hero p {
            font-size: 17px;
            color: var(--apple-text-secondary);
            margin-top: 8px;
        }

        /* Content */
        .profile-content {
            max-width: 800px;
            margin: -20px auto 60px;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }

        /* Avatar Card */
        .profile-header-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow-lg);
            padding: 40px;
            display: flex;
            align-items: center;
            gap: 32px;
            margin-bottom: 24px;
            animation: fadeUp 0.5s ease-out;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--apple-blue), #5856D6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #fff;
            font-weight: 600;
            flex-shrink: 0;
        }
        .profile-header-info h2 {
            font-size: 28px;
            font-weight: 600;
            letter-spacing: -0.5px;
        }
        .profile-header-info .role-badge {
            display: inline-block;
            margin-top: 8px;
            padding: 4px 14px;
            font-size: 12px;
            font-weight: 500;
            color: var(--apple-blue);
            background: rgba(0,122,255,0.08);
            border-radius: 980px;
        }

        /* Info Cards */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }
        .info-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 28px;
            animation: fadeUp 0.5s ease-out;
        }
        .info-card:nth-child(2) { animation-delay: 0.1s; }
        .info-card:nth-child(3) { animation-delay: 0.2s; }
        .info-card:nth-child(4) { animation-delay: 0.3s; }
        .info-card .info-label {
            font-size: 13px;
            font-weight: 500;
            color: var(--apple-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .info-card .info-value {
            font-size: 20px;
            font-weight: 600;
            color: var(--apple-text);
            letter-spacing: -0.3px;
        }

        /* Session Card */
        .session-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 28px;
            animation: fadeUp 0.5s ease-out 0.4s both;
        }
        .session-card h3 {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 16px;
            color: var(--apple-text);
        }
        .session-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--apple-bg);
            font-size: 14px;
        }
        .session-item:last-child { border-bottom: none; }
        .session-item .label { color: var(--apple-gray); }
        .session-item .value { color: var(--apple-text); font-weight: 500; }

        /* Actions */
        .profile-actions {
            display: flex;
            gap: 16px;
            margin-top: 24px;
            animation: fadeUp 0.5s ease-out 0.5s both;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 48px;
            padding: 0 28px;
            font-size: 15px;
            font-weight: 500;
            font-family: var(--apple-font);
            border-radius: 980px;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
        }
        .btn-primary {
            background: var(--apple-blue);
            color: #fff;
        }
        .btn-primary:hover { background: var(--apple-blue-hover); }
        .btn-secondary {
            background: var(--apple-bg);
            color: var(--apple-text);
        }
        .btn-secondary:hover { background: #E8E8ED; }

        @media (max-width: 768px) {
            .profile-header-card {
                flex-direction: column;
                text-align: center;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .profile-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="profile-hero">
    <h1>个人资料</h1>
    <p>管理你的账户信息</p>
</div>

<div class="profile-content">
    <div class="profile-header-card">
        <div class="avatar"><%= loginUser.substring(0, 1).toUpperCase() %></div>
        <div class="profile-header-info">
            <h2><%= loginUser %></h2>
            <span class="role-badge">已认证用户</span>
        </div>
    </div>

    <div class="info-grid">
        <div class="info-card">
            <div class="info-label">用户名</div>
            <div class="info-value"><%= loginUser %></div>
        </div>
        <div class="info-card">
            <div class="info-label">邮箱</div>
            <div class="info-value"><%= loginUser %>@apple.com</div>
        </div>
        <div class="info-card">
            <div class="info-label">手机</div>
            <div class="info-value">138 **** 8888</div>
        </div>
        <div class="info-card">
            <div class="info-label">身份</div>
            <div class="info-value">管理员</div>
        </div>
    </div>

    <div class="session-card">
        <h3>会话信息</h3>
        <div class="session-item">
            <span class="label">登录时间</span>
            <span class="value"><%= loginTime != null ? loginTime : "未知" %></span>
        </div>
        <div class="session-item">
            <span class="label">Session ID</span>
            <span class="value"><%= session.getId().substring(0, 8) %>...</span>
        </div>
        <div class="session-item">
            <span class="label">会话超时</span>
            <span class="value"><%= session.getMaxInactiveInterval() / 60 %> 分钟</span>
        </div>
        <div class="session-item">
            <span class="label">浏览器</span>
            <span class="value"><%= request.getHeader("User-Agent") != null
                    && request.getHeader("User-Agent").length() > 40
                    ? request.getHeader("User-Agent").substring(0, 40) + "..."
                    : request.getHeader("User-Agent") %></span>
        </div>
    </div>

    <div class="profile-actions">
        <a href="<%= ctx %>/foster.jsp" class="btn btn-primary">领养中心</a>
        <a href="<%= ctx %>/doLogout" class="btn btn-secondary">退出登录</a>
    </div>
</div>

</body>
</html>
