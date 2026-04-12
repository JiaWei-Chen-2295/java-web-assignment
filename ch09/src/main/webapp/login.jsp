<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户登录</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, 'Microsoft YaHei', Arial, sans-serif;
      min-height: 100vh;
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      display: flex; align-items: center; justify-content: center;
    }
    .card {
      background: rgba(255,255,255,0.95);
      backdrop-filter: blur(10px);
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.15);
      padding: 45px 40px;
      width: 400px;
      animation: fadeUp 0.6s ease-out;
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .card h2 {
      text-align: center;
      color: #333;
      font-weight: 600;
      font-size: 1.8em;
      margin-bottom: 8px;
    }
    .card .subtitle {
      text-align: center;
      color: #999;
      margin-bottom: 30px;
      font-size: 0.95em;
    }
    .success-msg {
      background: #f3fff3;
      color: #43a047;
      padding: 10px 16px;
      border-radius: 10px;
      font-size: 0.9em;
      margin-bottom: 20px;
      border-left: 4px solid #43a047;
    }
    .error-msg {
      background: #fff3f3;
      color: #e53935;
      padding: 10px 16px;
      border-radius: 10px;
      font-size: 0.9em;
      margin-bottom: 20px;
      border-left: 4px solid #e53935;
    }
    .form-group { margin-bottom: 22px; }
    .form-group label {
      display: block;
      margin-bottom: 6px;
      color: #555;
      font-size: 0.9em;
      font-weight: 500;
    }
    .form-group input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e8e8e8;
      border-radius: 12px;
      font-size: 1em;
      transition: all 0.3s;
      outline: none;
      background: #fafafa;
    }
    .form-group input:focus {
      border-color: #f093fb;
      background: #fff;
      box-shadow: 0 0 0 4px rgba(240,147,251,0.1);
    }
    .btn {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 1.05em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      margin-top: 10px;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(240,147,251,0.4);
    }
    .footer-link {
      text-align: center;
      margin-top: 25px;
      color: #999;
      font-size: 0.9em;
    }
    .footer-link a {
      color: #f093fb;
      text-decoration: none;
      font-weight: 500;
    }
    .footer-link a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="card">
    <h2>欢迎回来</h2>
    <p class="subtitle">请登录您的账号</p>

    <% if ("true".equals(String.valueOf(request.getAttribute("success")))) { %>
      <div class="success-msg">注册成功！请登录</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="error-msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="login" method="post">
      <div class="form-group">
        <label>用户名</label>
        <input type="text" name="username" placeholder="请输入用户名" required>
      </div>
      <div class="form-group">
        <label>密码</label>
        <input type="password" name="password" placeholder="请输入密码" required>
      </div>
      <button type="submit" class="btn">登 录</button>
    </form>

    <div class="footer-link">
      还没有账号？<a href="register.jsp">去注册</a>
    </div>
  </div>
</body>
</html>
