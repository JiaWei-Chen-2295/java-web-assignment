<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NoteApp - 登录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>

<div class="auth-page auth-page-v2">
    <div class="auth-card fade-in">
        <!-- Logo -->
        <div class="auth-logo">
            <div class="logo-icon"><i class="bi bi-journal-richtext"></i></div>
            <span class="logo-text">NoteApp</span>
        </div>

        <div class="auth-title">欢迎回来</div>
        <div class="auth-subtitle">登录你的账号，继续知识管理之旅</div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="auth-error">
                <i class="bi bi-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/user/login" method="post">
            <div class="form-group">
                <label class="form-label" for="username">
                    <i class="bi bi-person"></i> 用户名
                </label>
                <input type="text" class="form-input" id="username" name="username"
                       placeholder="请输入用户名" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label" for="password">
                    <i class="bi bi-lock"></i> 密码
                </label>
                <input type="password" class="form-input" id="password" name="password"
                       placeholder="请输入密码" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;height:40px;font-size:14px;margin-top:8px;">
                <i class="bi bi-box-arrow-in-right"></i> 登录
            </button>
        </form>

        <div class="auth-footer">
            还没有账号？
            <a href="${pageContext.request.contextPath}/user/register">立即注册</a>
        </div>
    </div>
</div>

</body>
</html>
