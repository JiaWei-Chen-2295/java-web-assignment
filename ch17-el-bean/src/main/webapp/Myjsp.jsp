<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录信息 - Session</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            max-width: 480px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 32px;
            font-size: 24px;
        }
        .info-card {
            background: #f0f8ff;
            border-radius: 10px;
            padding: 24px;
            margin-bottom: 20px;
        }
        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #e0e8f0;
        }
        .info-row:last-child { border-bottom: none; }
        .label {
            width: 100px;
            color: #666;
            font-size: 14px;
            flex-shrink: 0;
        }
        .value {
            color: #333;
            font-weight: 500;
        }
        .el-expr {
            color: #4facfe;
            font-family: "Consolas", "Courier New", monospace;
            font-size: 13px;
            margin-bottom: 8px;
        }
        .note {
            padding: 12px 16px;
            background: #e8f5e9;
            border-radius: 8px;
            font-size: 13px;
            color: #2e7d32;
            text-align: center;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #4facfe;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>会话登录信息</h1>

        <div class="info-card">
            <div class="el-expr">EL表达式: \${sessionScope.username}</div>
            <div class="info-row">
                <span class="label">用户名：</span>
                <span class="value">${sessionScope.username}</span>
            </div>

            <div class="el-expr" style="margin-top: 12px;">EL表达式: \${sessionScope.password}</div>
            <div class="info-row">
                <span class="label">密码：</span>
                <span class="value">${sessionScope.password}</span>
            </div>
        </div>

        <div class="note">
            Session ID: ${pageContext.session.id}
        </div>

        <a class="back-link" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
