<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*,fun.javierchen.ch11loginkeeper.*" %>
<%
    Cookie[] cookies = request.getCookies();
    Cookie userLoginCookie = null;
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("userLogin".equals(c.getName())) {
                userLoginCookie = c;
                break;
            }
        }
    }

    String username = (String) session.getAttribute("username");
    Long cookieCreatedAt = (Long) session.getAttribute("cookieCreatedAt");
    Integer cookieMaxAge = (Integer) session.getAttribute("cookieMaxAge");
    String cookiePath = (String) session.getAttribute("cookiePath");
    Boolean cookieHttpOnly = (Boolean) session.getAttribute("cookieHttpOnly");

    int remainingSeconds = -1;
    if (cookieCreatedAt != null) {
        long elapsed = System.currentTimeMillis() - cookieCreatedAt;
        remainingSeconds = Math.max(0, cookieMaxAge - (int)(elapsed / 1000));
    }

    boolean isLoggedIn = userLoginCookie != null && username != null;

    Map<String, UserInfo> activeSessions = SessionManager.getInstance().getActiveSessions();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>控制面板 - LoginKeeper</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .user-avatar {
            width: 48px;
            height: 48px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 20px;
            font-weight: 700;
        }
        .user-name {
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
        }
        .user-role {
            font-size: 13px;
            color: var(--gray-500);
        }
        .countdown-card {
            text-align: center;
            padding: 20px 28px;
            background: #fff;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
        }
        .countdown-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--gray-500);
            font-weight: 600;
            margin-bottom: 8px;
        }
        .countdown-value {
            font-family: 'SF Mono', 'Fira Code', monospace;
            font-size: 36px;
            font-weight: 800;
            color: var(--primary);
            line-height: 1;
        }
        .countdown-value.warning { color: var(--warning); }
        .countdown-value.danger { color: var(--danger); }
        .countdown-bar {
            width: 100%;
            height: 4px;
            background: var(--gray-200);
            border-radius: 2px;
            margin-top: 12px;
            overflow: hidden;
        }
        .countdown-bar-fill {
            height: 100%;
            background: var(--primary);
            border-radius: 2px;
            transition: width 1s linear;
        }
        .countdown-bar-fill.warning { background: var(--warning); }
        .countdown-bar-fill.danger { background: var(--danger); }

        .not-logged-in-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 64px - 80px);
        }
        .not-logged-in-card {
            text-align: center;
            max-width: 400px;
            padding: 48px 36px;
        }
        .not-logged-in-card .icon {
            font-size: 48px;
            margin-bottom: 16px;
        }
        .not-logged-in-card h2 {
            font-size: 20px;
            margin-bottom: 8px;
        }
        .not-logged-in-card p {
            color: var(--gray-600);
            margin-bottom: 24px;
        }

        .session-you {
            font-size: 11px;
            background: var(--primary-light);
            color: var(--primary);
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="login.jsp" class="navbar-brand">
            <span class="logo">L</span>
            LoginKeeper
        </a>
        <ul class="navbar-nav">
            <% if (isLoggedIn) { %>
            <li><a href="welcome.jsp" class="active">控制面板</a></li>
            <li><a href="logout" class="btn-nav">退出登录</a></li>
            <% } else { %>
            <li><a href="login.jsp">登录</a></li>
            <li><a href="register">注册</a></li>
            <% } %>
        </ul>
    </nav>

    <% if (isLoggedIn) { %>
    <div class="container">
        <div class="dashboard-header">
            <div class="user-info">
                <div class="user-avatar"><%= username.substring(0, 1).toUpperCase() %></div>
                <div>
                    <div class="user-name">欢迎，<%= username %></div>
                    <div class="user-role">已通过 Cookie 会话登录</div>
                </div>
            </div>
            <div class="countdown-card">
                <div class="countdown-label">Cookie 过期倒计时</div>
                <div class="countdown-value" id="countdown">
                    <%= remainingSeconds / 60 %>:<%= String.format("%02d", remainingSeconds % 60) %>
                </div>
                <div class="countdown-bar">
                    <div class="countdown-bar-fill" id="countdownBar"
                         style="width: <%= (remainingSeconds * 100.0 / cookieMaxAge) %>%">
                    </div>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= activeSessions.size() %></div>
                <div class="stat-label">活跃会话</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= cookieMaxAge / 60 %> 分钟</div>
                <div class="stat-label">Cookie 有效期</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= cookieHttpOnly ? "是" : "否" %></div>
                <div class="stat-label">HttpOnly</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= cookiePath %></div>
                <div class="stat-label">Cookie 路径</div>
            </div>
        </div>

        <div class="card section">
            <div class="card-header">
                <h2>活跃会话</h2>
            </div>
            <div class="card-body" style="padding: 0;">
                <table class="table">
                    <thead>
                        <tr>
                            <th>会话 ID</th>
                            <th>用户名</th>
                            <th>登录时间</th>
                            <th>状态</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map.Entry<String, UserInfo> entry : activeSessions.entrySet()) {
                            String sid = entry.getKey();
                            UserInfo ui = entry.getValue();
                            boolean isCurrent = sid.equals(session.getId());
                        %>
                        <tr class="<%= isCurrent ? "table-highlight" : "" %>">
                            <td><code style="font-size:12px; color:var(--gray-600);"><%= sid.substring(0, Math.min(12, sid.length())) %>...</code></td>
                            <td>
                                <strong><%= ui.getUsername() %></strong>
                                <% if (isCurrent) { %><span class="session-you">当前</span><% } %>
                            </td>
                            <td><%= new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date(ui.getLoginTime())) %></td>
                            <td><span class="badge badge-success">活跃</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="not-logged-in-wrapper">
        <div class="not-logged-in-card card card-body">
            <div class="icon">&#x1F512;</div>
            <h2>会话已过期</h2>
            <p>您的 Cookie 已过期或尚未登录。请重新登录以继续。</p>
            <a href="login.jsp" class="btn btn-primary">前往登录</a>
        </div>
    </div>
    <% } %>

    <footer class="footer">
        &copy; 2026 LoginKeeper &middot; Cookie 会话演示
    </footer>

    <%@ include file="/WEB-INF/jspf/debug-panel.jspf" %>

    <% if (isLoggedIn && cookieCreatedAt != null) { %>
    <script>
    (function() {
        var createdAt = <%= cookieCreatedAt %>;
        var maxAge = <%= cookieMaxAge %>;
        var total = maxAge;

        function update() {
            var elapsed = Math.floor((Date.now() - createdAt) / 1000);
            var remaining = Math.max(0, maxAge - elapsed);
            var pct = (remaining / total) * 100;

            var min = Math.floor(remaining / 60);
            var sec = remaining % 60;
            var el = document.getElementById('countdown');
            var bar = document.getElementById('countdownBar');

            if (el) {
                el.textContent = min + ':' + (sec < 10 ? '0' : '') + sec;
                el.className = 'countdown-value';
                if (remaining <= 30) el.classList.add('danger');
                else if (remaining <= 60) el.classList.add('warning');
            }
            if (bar) {
                bar.style.width = pct + '%';
                bar.className = 'countdown-bar-fill';
                if (remaining <= 30) bar.classList.add('danger');
                else if (remaining <= 60) bar.classList.add('warning');
            }
            if (remaining > 0) setTimeout(update, 1000);
        }
        update();
    })();
    </script>
    <% } %>
</body>
</html>
