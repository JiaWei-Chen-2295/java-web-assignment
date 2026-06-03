<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 使用下划线前缀避免与宿主页面变量冲突 --%>
<%
    String _navUser = (String) session.getAttribute("loginUser");
    String _navCtx = request.getContextPath();
%>
<style>
    .apple-nav {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 52px;
        background: rgba(255, 255, 255, 0.72);
        backdrop-filter: saturate(180%) blur(20px);
        -webkit-backdrop-filter: saturate(180%) blur(20px);
        border-bottom: 0.5px solid rgba(0, 0, 0, 0.08);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 40px;
        z-index: 9999;
        font-family: var(--apple-font);
    }
    .apple-nav .nav-logo {
        font-size: 18px;
        font-weight: 600;
        color: var(--apple-text);
        text-decoration: none;
        letter-spacing: -0.3px;
    }
    .apple-nav .nav-links {
        display: flex;
        gap: 32px;
        align-items: center;
    }
    .apple-nav .nav-links a {
        font-size: 13px;
        font-weight: 400;
        color: var(--apple-gray);
        text-decoration: none;
        transition: color 0.2s ease;
        letter-spacing: -0.1px;
    }
    .apple-nav .nav-links a:hover,
    .apple-nav .nav-links a.active {
        color: var(--apple-text);
    }
    .apple-nav .nav-right {
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .apple-nav .nav-user {
        font-size: 13px;
        color: var(--apple-text);
        font-weight: 500;
    }
    .apple-nav .nav-logout {
        font-size: 12px;
        color: var(--apple-blue);
        text-decoration: none;
        font-weight: 400;
        padding: 4px 12px;
        border: 1px solid var(--apple-blue);
        border-radius: 980px;
        transition: all 0.2s ease;
    }
    .apple-nav .nav-logout:hover {
        background: var(--apple-blue);
        color: #fff;
    }
    @media (max-width: 768px) {
        .apple-nav {
            padding: 0 20px;
        }
        .apple-nav .nav-links {
            gap: 16px;
        }
        .apple-nav .nav-links a {
            font-size: 11px;
        }
    }
</style>

<nav class="apple-nav">
    <a href="<%= _navCtx %>/index.jsp" class="nav-logo">&#63743; Profile</a>
    <div class="nav-links">
        <a href="<%= _navCtx %>/introduce.jsp" class="<%= "introduce".equals(request.getParameter("p")) ? "active" : "" %>">关于</a>
        <% if (_navUser != null) { %>
        <a href="<%= _navCtx %>/profile.jsp" class="<%= "profile".equals(request.getParameter("p")) ? "active" : "" %>">个人资料</a>
        <a href="<%= _navCtx %>/foster.jsp" class="<%= "foster".equals(request.getParameter("p")) ? "active" : "" %>">领养中心</a>
        <% } %>
    </div>
    <div class="nav-right">
        <% if (_navUser != null) { %>
        <span class="nav-user"><%= _navUser %></span>
        <a href="<%= _navCtx %>/doLogout" class="nav-logout">退出登录</a>
        <% } else { %>
        <a href="<%= _navCtx %>/login-session.jsp" class="nav-logout">登录</a>
        <% } %>
    </div>
</nav>
