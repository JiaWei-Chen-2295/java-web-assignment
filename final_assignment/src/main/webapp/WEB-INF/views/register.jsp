<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NoteApp - 注册</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>

<div class="auth-page">
    <div class="auth-card fade-in">
        <!-- Logo -->
        <div class="auth-logo">
            <div class="logo-icon"><i class="bi bi-journal-richtext"></i></div>
            <span class="logo-text">NoteApp</span>
        </div>

        <div class="auth-title">创建账号</div>
        <div class="auth-subtitle">加入 NoteApp，开始管理你的知识</div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="auth-error">
                <i class="bi bi-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Register Form -->
        <form action="${pageContext.request.contextPath}/user/register" method="post">
            <div class="form-group">
                <label class="form-label" for="username">
                    <i class="bi bi-person"></i> 用户名
                </label>
                <input type="text" class="form-input" id="username" name="username"
                       placeholder="请输入用户名" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label" for="email">
                    <i class="bi bi-envelope"></i> 邮箱
                </label>
                <input type="email" class="form-input" id="email" name="email"
                       placeholder="请输入邮箱地址" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="password">
                    <i class="bi bi-lock"></i> 密码
                </label>
                <input type="password" class="form-input" id="password" name="password"
                       placeholder="请输入密码" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="confirmPassword">
                    <i class="bi bi-lock-fill"></i> 确认密码
                </label>
                <input type="password" class="form-input" id="confirmPassword" name="confirmPassword"
                       placeholder="请再次输入密码" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;height:40px;font-size:14px;margin-top:8px;">
                <i class="bi bi-check-circle"></i> 注册
            </button>
        </form>

        <div class="auth-footer">
            已有账号？
            <a href="${pageContext.request.contextPath}/user/login">立即登录</a>
        </div>
    </div>
</div>

</body>
</html>
