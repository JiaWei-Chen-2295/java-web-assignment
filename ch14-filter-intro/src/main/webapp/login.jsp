<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.Random" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户登录 - Filter 综合演示</title>
    <link rel="stylesheet" href="css/claude-design.css">
    <style>
        .captcha-box {
            display: inline-block;
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            padding: 8px 18px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 26px;
            font-weight: bold;
            letter-spacing: 8px;
            color: #333;
            text-decoration: line-through;
            user-select: none;
            border: 1px solid #e8a87c;
        }
        .form-row {
            display: flex;
            align-items: flex-end;
            gap: 12px;
        }
        .form-row label { flex: 1; }
        .captcha-refresh {
            display: inline-block;
            margin-bottom: 10px;
            color: var(--cl-accent-2);
            cursor: pointer;
            text-decoration: underline;
            font-size: 13px;
        }
        .error-msg {
            color: #c0392b;
            font-weight: bold;
            padding: 8px 12px;
            background: #fdf0ef;
            border-left: 4px solid #c0392b;
            border-radius: 4px;
            margin: 8px 0;
        }
        .demo-guide {
            background: #f0f7ff;
            border: 1px solid #b8d4f0;
            border-radius: 12px;
            padding: 16px;
            margin-top: 16px;
        }
        .demo-guide h3 {
            margin-top: 0;
            color: #2c5282;
            font-size: 15px;
        }
        .demo-guide ol {
            margin: 8px 0 0 0;
            padding-left: 20px;
            font-size: 13px;
            line-height: 2;
        }
        .demo-guide code {
            background: #e2ecf6;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
        }
        .demo-guide .step-tag {
            display: inline-block;
            background: #3182ce;
            color: #fff;
            padding: 1px 8px;
            border-radius: 10px;
            font-size: 11px;
            margin-right: 4px;
        }
        .filter-chain {
            background: #1a202c;
            color: #e2e8f0;
            padding: 14px;
            border-radius: 10px;
            font-family: Consolas, monospace;
            font-size: 12px;
            line-height: 1.8;
            margin-top: 12px;
        }
        .filter-chain .arrow { color: #63b3ed; }
        .filter-chain .highlight { color: #fc8181; font-weight: bold; }
    </style>
</head>
<body class="theme-root">
<%
    // 生成 4 位随机验证码，存入 session
    Random rand = new Random();
    String captcha = String.format("%04d", rand.nextInt(10000));
    session.setAttribute("captcha", captcha);

    // 错误信息
    String captchaError = (String) request.getAttribute("captchaError");
    String loginError = request.getParameter("error");
    String savedUsername = (String) request.getAttribute("username");
    if (savedUsername == null) savedUsername = "";
%>

<main class="container">
    <!-- 登录表单 -->
    <section class="panel">
        <h2>用户登录</h2>
        <p class="muted">LoginValidatorFilter 验证码校验 → LoginServlet 身份认证 → PermissionFilter 权限控制</p>

        <%-- 验证码错误（由 Filter forward 回来） --%>
        <% if (captchaError != null) { %>
            <div class="error-msg"><%= captchaError %></div>
        <% } %>

        <%-- 用户名密码错误（由 LoginServlet redirect 回来） --%>
        <% if ("1".equals(loginError)) { %>
            <div class="error-msg">用户名或密码错误！</div>
        <% } %>

        <%-- 未登录直接访问受保护资源（由 PermissionFilter redirect 回来） --%>
        <% if ("2".equals(loginError)) { %>
            <div class="error-msg">请先登录后再访问受保护资源。</div>
        <% } %>

        <form class="form-grid" action="login" method="post">
            <label>用户名
                <input type="text" name="username" placeholder="admin 或 user"
                       value="<%= savedUsername %>" required>
            </label>
            <label>密码
                <input type="password" name="password" placeholder="123456" required>
            </label>
            <label>验证码
                <div class="form-row">
                    <input type="text" name="captcha" placeholder="输入 4 位数字"
                           maxlength="4" style="flex:1;" required>
                    <span class="captcha-box"><%= captcha %></span>
                </div>
            </label>
            <button class="btn" type="submit">登 录</button>
        </form>

        <div class="link-list" style="margin-top:12px;">
            <a href="index.jsp">返回首页</a>
            <a href="register.jsp">注册新用户</a>
        </div>
    </section>

    <!-- 过滤器链路说明 -->
    <section class="panel">
        <h3>请求处理链路</h3>
        <div class="filter-chain">
            <span class="highlight">POST /login</span><br>
            &nbsp;&nbsp;<span class="arrow">↓</span> <strong>LoginValidatorFilter</strong> — 校验验证码<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✗ 验证码错误</span> → forward 回 login.jsp<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✓ 验证码正确</span> → chain 放行 ↓<br>
            &nbsp;&nbsp;<strong>LoginServlet</strong> — 校验用户名密码<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✗ 密码错误</span> → redirect login.jsp?error=1<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✓ admin</span> → redirect /admin/admin.jsp<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✓ user</span> → redirect /user/user.jsp<br><br>
            <span class="highlight">GET /admin/* 或 /user/*</span><br>
            &nbsp;&nbsp;<span class="arrow">↓</span> <strong>PermissionFilter</strong> — 检查 session 登录状态与角色<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✗ 未登录</span> → redirect login.jsp?error=2<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✗ 角色不匹配</span> → 403 Forbidden<br>
            &nbsp;&nbsp;&nbsp;&nbsp;<span class="arrow">✓ 权限通过</span> → 访问目标资源
        </div>
    </section>

    <!-- 演示操作引导 -->
    <section class="panel demo-guide">
        <h3>演示操作引导</h3>
        <ol>
            <li>
                <span class="step-tag">正常登录</span>
                输入 <code>admin</code> / <code>123456</code> + 页面显示的验证码 → 进入<strong>管理员控制台</strong>
            </li>
            <li>
                <span class="step-tag">普通用户</span>
                退出后输入 <code>user</code> / <code>123456</code> + 验证码 → 进入<strong>用户中心</strong>
            </li>
            <li>
                <span class="step-tag">验证码错误</span>
                输入任意用户名密码，验证码故意输错 → LoginValidatorFilter 拦截，提示重新输入
            </li>
            <li>
                <span class="step-tag">密码错误</span>
                输入正确验证码，但密码输错 → LoginServlet 拦截，提示用户名或密码错误
            </li>
            <li>
                <span class="step-tag">越权访问</span>
                以 <code>user</code> 登录后，手动访问 <code>/admin/admin.jsp</code> → 403 权限不足
            </li>
            <li>
                <span class="step-tag">未登录访问</span>
                退出后直接访问 <code>/admin/admin.jsp</code> 或 <code>/user/user.jsp</code> → PermissionFilter 拦截，跳回登录页
            </li>
        </ol>
    </section>

    <!-- 测试入口 -->
    <section class="panel">
        <h3>快速测试入口</h3>
        <div class="link-list">
            <a href="admin/admin.jsp">直接访问 管理员控制台（测试未登录拦截）</a>
            <a href="user/user.jsp">直接访问 用户中心（测试未登录拦截）</a>
        </div>
    </section>
</main>
</body>
</html>
