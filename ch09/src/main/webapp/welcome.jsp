<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String loginUser = (String) session.getAttribute("loginUser");
  if (loginUser == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>欢迎</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, 'Microsoft YaHei', Arial, sans-serif;
      min-height: 100vh;
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      display: flex; align-items: center; justify-content: center;
    }
    .card {
      background: rgba(255,255,255,0.95);
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.15);
      padding: 50px 40px;
      width: 420px;
      text-align: center;
      animation: fadeUp 0.6s ease-out;
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .avatar {
      width: 80px; height: 80px;
      background: linear-gradient(135deg, #43e97b, #38f9d7);
      border-radius: 50%;
      margin: 0 auto 20px;
      display: flex; align-items: center; justify-content: center;
      font-size: 2.2em;
      color: white;
    }
    .card h2 { color: #333; font-size: 1.6em; margin-bottom: 10px; }
    .card p { color: #888; margin-bottom: 30px; }
    .logout-btn {
      display: inline-block;
      padding: 12px 40px;
      background: linear-gradient(135deg, #43e97b, #38f9d7);
      color: white;
      text-decoration: none;
      border-radius: 12px;
      font-weight: 600;
      transition: all 0.3s;
    }
    .logout-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(67,233,123,0.4);
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="avatar">&#128075;</div>
    <h2>你好，<%= loginUser %>！</h2>
    <p>登录成功，欢迎使用本系统</p>
    <a href="logout" class="logout-btn">退出登录</a>
  </div>
</body>
</html>
