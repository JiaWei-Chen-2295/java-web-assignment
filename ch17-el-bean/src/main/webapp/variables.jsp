<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>作用域变量 - EL表达式</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            max-width: 600px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 32px;
            font-size: 24px;
        }
        .scope-section {
            margin-bottom: 24px;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }
        .scope-header {
            padding: 12px 16px;
            font-weight: 600;
            font-size: 15px;
            color: #fff;
        }
        .scope-header.page { background: #667eea; }
        .scope-header.request { background: #f5576c; }
        .scope-header.session { background: #11998e; }
        .scope-header.application { background: #f093fb; }
        .scope-body { padding: 16px; background: #fafafa; }
        .var-row {
            display: flex;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .var-row:last-child { border-bottom: none; }
        .var-name {
            width: 180px;
            color: #555;
            font-family: "Consolas", "Courier New", monospace;
        }
        .var-value { color: #333; font-weight: 500; }
        .note {
            margin-top: 20px;
            padding: 12px 16px;
            background: #fff3cd;
            border-radius: 8px;
            font-size: 13px;
            color: #856404;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 24px;
            color: #f5576c;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL表达式访问不同作用域变量</h1>

        <div class="scope-section">
            <div class="scope-header page">Page 作用域</div>
            <div class="scope-body">
                <div class="var-row">
                    <span class="var-name">\${attrib1}</span>
                    <span class="var-value">${attrib1}</span>
                </div>
                <div class="var-row">
                    <span class="var-name">\${attrib2}</span>
                    <span class="var-value">${attrib2}</span>
                </div>
                <div class="var-row">
                    <span class="var-name">\${attrib3}</span>
                    <span class="var-value">${attrib3}</span>
                </div>
            </div>
        </div>

        <div class="scope-section">
            <div class="scope-header request">Request 作用域 (attrib4)</div>
            <div class="scope-body">
                <div class="var-row">
                    <span class="var-name">\${requestScope.attrib4}</span>
                    <span class="var-value">${requestScope.attrib4}</span>
                </div>
            </div>
        </div>

        <div class="scope-section">
            <div class="scope-header session">Session 作用域 (attrib4)</div>
            <div class="scope-body">
                <div class="var-row">
                    <span class="var-name">\${sessionScope.attrib4}</span>
                    <span class="var-value">${sessionScope.attrib4}</span>
                </div>
            </div>
        </div>

        <div class="scope-section">
            <div class="scope-header application">Application 作用域 (attrib4)</div>
            <div class="scope-body">
                <div class="var-row">
                    <span class="var-name">\${applicationScope.attrib4}</span>
                    <span class="var-value">${applicationScope.attrib4}</span>
                </div>
            </div>
        </div>

        <div class="note">
            <strong>说明：</strong>当多个作用域存在同名变量 attrib4 时，EL 表达式默认按
            page &gt; request &gt; session &gt; application 的顺序查找。
            使用 \${attrib4} 将返回 <strong>${attrib4}</strong>（request作用域优先）。
            要访问特定作用域，需使用 \${scope.attrib4} 的形式。
        </div>

        <a class="back-link" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
