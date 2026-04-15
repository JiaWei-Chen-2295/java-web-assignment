<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String tab = request.getParameter("action");
    boolean isReadMode = "readCookie".equals(tab);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cookie练习</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #e3f2fd 0%, #fff3e0 100%);
            color: #333; line-height: 1.6; min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #1976d2 0%, #42a5f5 100%);
            color: white; text-align: center; padding: 25px 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .header h1 { font-size: 2.2em; font-weight: 300; letter-spacing: 3px; }
        
        .nav {
            background: rgba(255,255,255,0.95); padding: 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .nav ul {
            list-style: none; display: flex; justify-content: center;
            max-width: 800px; margin: 0 auto; flex-wrap: wrap;
        }
        .nav li { position: relative; }
        .nav a {
            display: block; padding: 15px 25px; color: #1976d2; text-decoration: none;
            font-weight: 500; transition: all 0.3s; border-bottom: 3px solid transparent;
        }
        .nav a:hover, .nav a.active {
            background: #e3f2fd; border-bottom-color: #1976d2; color: #1565c0;
        }
        
        .container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        
        .card {
            background: white; border-radius: 12px; padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); margin-bottom: 20px;
        }
        .card h2 { color: #1976d2; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #e3f2fd; }
        
        label { display: block; margin-bottom: 15px; }
        label span { display: inline-block; width: 100px; font-weight: 500; color: #555; }
        input[type="text"], input[type="number"] { 
            width: 220px; padding: 10px; margin: 0; 
            border: 1px solid #ccc; border-radius: 6px; font-size: 14px;
        }
        input[type="text"]:focus, input[type="number"]:focus {
            outline: none; border-color: #1976d2;
        }
        
        button { 
            background: #1976d2; color: white; padding: 12px 30px; 
            border: none; border-radius: 6px; cursor: pointer; font-size: 14px;
            transition: all 0.3s;
        }
        button:hover { background: #1565c0; transform: translateY(-2px); }
        
        table { border-collapse: collapse; width: 100%; margin-top: 15px; }
        th, td { border: 1px solid #e0e0e0; padding: 12px; text-align: left; }
        th { background: #f5f5f5; color: #555; }
        td { color: #333; }
        
        .message { 
            background: #c8e6c9; color: #2e7d32; padding: 15px; 
            border-radius: 8px; margin-bottom: 20px;
        }
        
        .empty { color: #888; text-align: center; padding: 30px; }
        
        .btn-small {
            background: #42a5f5; padding: 8px 16px; font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Cookie 练习</h1>
    </div>
    
    <nav class="nav">
        <ul>
            <li><a href="cookie-practice" class="<%= !isReadMode ? "active" : "" %>">发送Cookie</a></li>
            <li><a href="cookie-practice?action=readCookie" class="<%= isReadMode ? "active" : "" %>">读取Cookie</a></li>
        </ul>
    </nav>

    <div class="container">
        <% if (request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>

        <% if (!isReadMode) { %>
        <div class="card">
            <h2>练习1：向客户端发送Cookie</h2>
            <form method="post">
                <input type="hidden" name="action" value="setCookie">
                <label>
                    <span>Cookie名称</span>
                    <input type="text" name="cookieName" placeholder="如: username">
                </label>
                <label>
                    <span>Cookie值</span>
                    <input type="text" name="cookieValue" placeholder="如: javierchen">
                </label>
                <label>
                    <span>有效期(秒)</span>
                    <input type="number" name="maxAge" value="86400" placeholder="默认86400(1天)">
                </label>
                <button type="submit">发送Cookie</button>
            </form>
        </div>
        <% } else { %>
        <div class="card">
            <h2>练习2：从客户端读取Cookie</h2>
            <p><a href="javascript:location.reload()"><button class="btn-small">刷新查看Cookie</button></a></p>
        </div>
        <% } %>

        <%
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
        %>
        <div class="card">
            <h2>客户端返回的Cookie列表</h2>
            <table>
                <tr><th>名称</th><th>值</th><th>路径</th><th>有效期(秒)</th></tr>
                <% for (Cookie c : cookies) { %>
                <tr>
                    <td><%= c.getName() %></td>
                    <td><%= c.getValue() %></td>
                    <td><%= c.getPath() != null ? c.getPath() : "/" %></td>
                    <td><%= c.getMaxAge() %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } else { %>
        <div class="card">
            <p class="empty">暂无Cookie，请先发送Cookie</p>
        </div>
        <% } %>
    </div>
</body>
</html>