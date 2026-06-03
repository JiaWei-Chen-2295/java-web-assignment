<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户中心</title>
    <link rel="stylesheet" href="../css/claude-design.css">
    <style>
        .role-badge {
            display: inline-block;
            background: #3182ce;
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
        <h2>用户中心 <span class="role-badge">USER</span></h2>
        <p class="muted">此页面对已登录用户开放，PermissionFilter 已验证登录状态。</p>

        <div class="session-info">
            <strong>登录用户：</strong><%= session.getAttribute("username") %><br>
            <strong>用户角色：</strong><%= session.getAttribute("role") %><br>
            <strong>Session ID：</strong><%= session.getId() %>
        </div>

        <div class="link-list" style="margin-top: 16px;">
            <a href="${pageContext.request.contextPath}/admin/admin.jsp">访问管理后台（测试 user 越权 → 403）</a>
            <a href="${pageContext.request.contextPath}/index.jsp">返回首页</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </section>

    <section class="panel">
        <h3>演示说明</h3>
        <p class="muted">
            当前以 <strong>user</strong> 身份登录，仅拥有普通用户权限。<br>
            点击上方"访问管理后台"可验证 PermissionFilter 会拦截 user 角色访问 /admin/* 资源（返回 403）。
        </p>
    </section>
</main>
</body>
</html>
