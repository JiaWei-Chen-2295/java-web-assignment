<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理后台</title>
    <link rel="stylesheet" href="../css/claude-design.css">
    <style>
        .role-badge {
            display: inline-block;
            background: #e53e3e;
            color: #fff;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .session-info {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            font-size: 13px;
            line-height: 1.8;
        }
        .session-info strong { color: #2d3748; }
    </style>
</head>
<body class="theme-root">
<main class="container">
    <section class="panel">
        <h2>管理员控制台 <span class="role-badge">ADMIN</span></h2>
        <p class="muted">此页面仅对 admin 角色用户开放，PermissionFilter 已验证权限。</p>

        <div class="session-info">
            <strong>登录用户：</strong><%= session.getAttribute("username") %><br>
            <strong>用户角色：</strong><%= session.getAttribute("role") %><br>
            <strong>Session ID：</strong><%= session.getId() %>
        </div>

        <div class="link-list" style="margin-top: 16px;">
            <a href="${pageContext.request.contextPath}/user/user.jsp">访问用户中心（测试 admin 跨角色访问）</a>
            <a href="${pageContext.request.contextPath}/index.jsp">返回首页</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </section>

    <section class="panel">
        <h3>演示说明</h3>
        <p class="muted">
            当前以 <strong>admin</strong> 身份登录，拥有管理员权限。<br>
            点击上方"访问用户中心"可验证 admin 也能访问 user 资源（admin 角色权限更高）。
        </p>
    </section>
</main>
</body>
</html>
