<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户注册</title>
    <link rel="stylesheet" href="css/claude-design.css">
</head>
<body class="theme-root">
<main class="container">
    <section class="panel">
        <h2>用户注册</h2>
        <p class="muted">ResValidatorFilter 将验证用户名（3~20位）和密码（6~20位）的长度。</p>

        <%-- 显示过滤器回传的错误信息 --%>
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <p style="color: #c0392b; font-weight: bold;"><%= errorMsg %></p>
        <%  } %>

        <form class="form-grid" action="register" method="post" accept-charset="UTF-8">
            <label>用户名
                <input type="text" name="username" placeholder="3~20 位字符"
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
            </label>
            <label>昵称
                <input type="text" name="nickname" placeholder="例如：小明"
                       value="<%= request.getAttribute("nickname") != null ? request.getAttribute("nickname") : "" %>">
            </label>
            <label>密码
                <input type="password" name="password" placeholder="6~20 位字符">
            </label>
            <button class="btn" type="submit">提交注册</button>
        </form>

        <div class="link-list" style="margin-top: 16px;">
            <a href="index.jsp">返回首页</a>
        </div>
    </section>
</main>
</body>
</html>
