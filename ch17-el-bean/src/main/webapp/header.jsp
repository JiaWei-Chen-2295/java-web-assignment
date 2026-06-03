<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL 隐含对象 header & cookie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 640px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 28px; font-size: 24px; }
        .section {
            border-radius: 10px; padding: 20px;
            margin-bottom: 24px; border: 1px solid #e0e0e0;
        }
        .section.header { background: #ede7f6; }
        .section.cookie { background: #e8eaf6; }
        .section h3 { margin-bottom: 12px; font-size: 15px; }
        .section.header h3 { color: #4a148c; }
        .section.cookie h3 { color: #1a237e; }
        .info-row {
            display: flex; padding: 8px 0; border-bottom: 1px solid rgba(0,0,0,0.06);
            font-size: 14px;
        }
        .info-row:last-child { border-bottom: none; }
        .label { width: 220px; color: #888; font-family: "Consolas", monospace; font-size: 13px; }
        .value { color: #333; word-break: break-all; }
        .note {
            padding: 12px; background: #fff3e0; border-radius: 8px;
            font-size: 13px; color: #e65100; margin-bottom: 20px;
        }
        .back { display: block; text-align: center; margin-top: 20px; color: #6a11cb; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL 隐含对象: header & cookie</h1>

        <div class="note">
            \${header["user-agent"]} 获取请求头；\${cookie.user.value} 获取 Cookie 值。
        </div>

        <div class="section header">
            <h3>header 隐含对象 - 请求头信息</h3>
            <div class="info-row">
                <span class="label">\${header.host}</span>
                <span class="value">${header.host}</span>
            </div>
            <div class="info-row">
                <span class="label">\${header["user-agent"]}</span>
                <span class="value">${header["user-agent"]}</span>
            </div>
            <div class="info-row">
                <span class="label">\${header.accept}</span>
                <span class="value">${header.accept}</span>
            </div>
            <div class="info-row">
                <span class="label">\${header["accept-language"]}</span>
                <span class="value">${header["accept-language"]}</span>
            </div>
            <div class="info-row">
                <span class="label">\${header.referer}</span>
                <span class="value">${header.referer}</span>
            </div>
        </div>

        <div class="section cookie">
            <h3>cookie 隐含对象 - Cookie 信息</h3>
            <div class="info-row">
                <span class="label">\${cookie.user.value}</span>
                <span class="value">${cookie.user.value}</span>
            </div>
            <div class="info-row">
                <span class="label">\${cookie.theme.value}</span>
                <span class="value">${cookie.theme.value}</span>
            </div>
            <div class="info-row">
                <span class="label">\${cookie.lang.value}</span>
                <span class="value">${cookie.lang.value}</span>
            </div>
            <div class="info-row">
                <span class="label">\${cookie.JSESSIONID.value}</span>
                <span class="value">${cookie.JSESSIONID.value}</span>
            </div>
        </div>

        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
