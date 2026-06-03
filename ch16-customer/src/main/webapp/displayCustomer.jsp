<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fun.javierchen.ch16customer.Customer" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");

    if (customer == null) {
        response.sendRedirect("inputCustomer.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>客户信息展示</title>
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
            margin-bottom: 28px;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #3b82f6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: 700;
            color: #fff;
            margin: 0 auto 12px;
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.3);
        }

        .customer-name {
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            color: #f1f5f9;
            margin-bottom: 4px;
        }

        .customer-id {
            text-align: center;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 28px;
        }

        .info-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 28px;
        }

        .info-item {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 14px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideIn 0.4s ease-out backwards;
        }

        .info-item:nth-child(1) { animation-delay: 0.05s; }
        .info-item:nth-child(2) { animation-delay: 0.1s; }
        .info-item:nth-child(3) { animation-delay: 0.15s; }
        .info-item:nth-child(4) { animation-delay: 0.2s; }
        .info-item:nth-child(5) { animation-delay: 0.25s; }
        .info-item:nth-child(6) { animation-delay: 0.3s; }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .info-item .label {
            font-size: 13px;
            color: #94a3b8;
            font-weight: 500;
        }

        .info-item .value {
            font-size: 15px;
            font-weight: 600;
            color: #f1f5f9;
        }

        .info-item.highlight {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.12), rgba(59, 130, 246, 0.12));
            border-color: rgba(129, 140, 248, 0.2);
        }

        .btn-back {
            display: block;
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #6366f1, #3b82f6);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
        }

        .empty-hint {
            text-align: center;
            color: #64748b;
            padding: 20px 0;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>客户信息</h1>

        <div class="avatar"><%= customer.getName().substring(0, 1) %></div>
        <div class="customer-name"><%= customer.getName() %></div>
        <div class="customer-id">学号：<%= customer.getStudentId() %></div>

        <ul class="info-list">
            <li class="info-item highlight">
                <span class="label">学号</span>
                <span class="value"><%= customer.getStudentId() %></span>
            </li>
            <li class="info-item highlight">
                <span class="label">姓名</span>
                <span class="value"><%= customer.getName() %></span>
            </li>
            <li class="info-item">
                <span class="label">性别</span>
                <span class="value"><%= customer.getGender() %></span>
            </li>
            <li class="info-item">
                <span class="label">电话</span>
                <span class="value"><%= customer.getPhone() != null && !customer.getPhone().isEmpty() ? customer.getPhone() : "未填写" %></span>
            </li>
            <li class="info-item">
                <span class="label">邮箱</span>
                <span class="value"><%= customer.getEmail() != null && !customer.getEmail().isEmpty() ? customer.getEmail() : "未填写" %></span>
            </li>
            <li class="info-item">
                <span class="label">地址</span>
                <span class="value"><%= customer.getAddress() != null && !customer.getAddress().isEmpty() ? customer.getAddress() : "未填写" %></span>
            </li>
        </ul>

        <a href="inputCustomer.jsp" class="btn-back">重新录入</a>
    </div>
</body>
</html>
