<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>客户信息录入</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f172a, #1e293b, #0f172a);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: #e0e0e0;
            padding: 20px;
        }

        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 44px 40px;
            width: 480px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            animation: fadeUp 0.6s ease-out;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card h1 {
            text-align: center;
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 6px;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            text-align: center;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 28px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #94a3b8;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            font-size: 15px;
            color: #fff;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8'%3E%3Cpath d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
        }

        .form-group select option {
            background: #1e293b;
            color: #fff;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #818cf8;
            box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.2);
            background: rgba(255, 255, 255, 0.1);
        }

        .form-group input::placeholder {
            color: #475569;
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #6366f1, #3b82f6);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 8px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .error-msg {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.25);
            border-radius: 10px;
            padding: 11px 14px;
            margin-bottom: 18px;
            color: #fca5a5;
            font-size: 14px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>客户信息录入</h1>
        <p class="subtitle">请填写以下客户信息</p>

        <% if (error != null) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="customer" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="studentId">学号</label>
                    <input type="text" id="studentId" name="studentId"
                           placeholder="请输入学号" required autofocus>
                </div>
                <div class="form-group">
                    <label for="name">姓名</label>
                    <input type="text" id="name" name="name"
                           placeholder="请输入姓名" required>
                </div>
            </div>

            <div class="form-group">
                <label for="gender">性别</label>
                <select id="gender" name="gender">
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phone">电话</label>
                <input type="tel" id="phone" name="phone"
                       placeholder="请输入电话号码">
            </div>

            <div class="form-group">
                <label for="email">邮箱</label>
                <input type="email" id="email" name="email"
                       placeholder="请输入邮箱地址">
            </div>

            <div class="form-group">
                <label for="address">地址</label>
                <input type="text" id="address" name="address"
                       placeholder="请输入地址">
            </div>

            <button type="submit" class="btn">提交</button>
        </form>
    </div>
</body>
</html>
