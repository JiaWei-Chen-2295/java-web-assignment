<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>客户信息 - Java Bean</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 40px;
            max-width: 520px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 32px;
            font-size: 24px;
        }
        .info-group {
            margin-bottom: 20px;
        }
        .info-group h3 {
            color: #11998e;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
            padding-bottom: 6px;
            border-bottom: 2px solid #e0e0e0;
        }
        .info-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child { border-bottom: none; }
        .label {
            width: 100px;
            color: #888;
            font-size: 14px;
            flex-shrink: 0;
        }
        .value {
            color: #333;
            font-weight: 500;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 24px;
            color: #11998e;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>客户信息展示</h1>

        <div class="info-group">
            <h3>基本信息</h3>
            <div class="info-row">
                <span class="label">用户名：</span>
                <span class="value">${employee.id} ${employee.name}</span>
            </div>
        </div>

        <div class="info-group">
            <h3>地址信息</h3>
            <div class="info-row">
                <span class="label">省份：</span>
                <span class="value">${employee.address.province}</span>
            </div>
            <div class="info-row">
                <span class="label">城市：</span>
                <span class="value">${employee.address.city}</span>
            </div>
            <div class="info-row">
                <span class="label">街道：</span>
                <span class="value">${employee.address.street}</span>
            </div>
            <div class="info-row">
                <span class="label">完整地址：</span>
                <span class="value">${employee.address.fullAddress}</span>
            </div>
        </div>

        <a class="back-link" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
