<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL 隐含对象 param</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 560px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 28px; font-size: 24px; }
        .section {
            background: #fff8e1; border-radius: 10px; padding: 20px;
            margin-bottom: 20px; border: 1px solid #ffe082;
        }
        .section h3 { color: #e65100; margin-bottom: 12px; font-size: 15px; }
        .info-row {
            display: flex; padding: 8px 0; border-bottom: 1px solid #fff3e0;
            font-size: 14px;
        }
        .info-row:last-child { border-bottom: none; }
        .label { width: 180px; color: #888; font-family: "Consolas", monospace; }
        .value { color: #333; font-weight: 500; }
        .note {
            padding: 12px; background: #fce4ec; border-radius: 8px;
            font-size: 13px; color: #880e4f; margin-bottom: 20px;
        }
        .test-form { display: flex; gap: 8px; margin-bottom: 16px; }
        .test-form input {
            flex: 1; padding: 10px 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px;
        }
        .test-form button {
            padding: 10px 20px; background: #fa709a; color: #fff; border: none;
            border-radius: 8px; cursor: pointer; font-size: 14px;
        }
        .back { display: block; text-align: center; margin-top: 20px; color: #e65100; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL 隐含对象: param</h1>

        <div class="note">
            \${param.name} 等价于 request.getParameter("name")，返回单个字符串值。
        </div>

        <form class="test-form" method="get" action="param.jsp">
            <input type="text" name="name" placeholder="输入姓名" value="${param.name}">
            <input type="text" name="age" placeholder="输入年龄" value="${param.age}">
            <button type="submit">提交</button>
        </form>

        <div class="section">
            <h3>param 隐含对象 - 获取单个参数</h3>
            <div class="info-row">
                <span class="label">\${param.name}</span>
                <span class="value">${param.name}</span>
            </div>
            <div class="info-row">
                <span class="label">\${param.age}</span>
                <span class="value">${param.age}</span>
            </div>
            <div class="info-row">
                <span class="label">\${param["name"]}</span>
                <span class="value">${param["name"]}</span>
            </div>
        </div>

        <div class="section">
            <h3>与 empty 结合判断</h3>
            <div class="info-row">
                <span class="label">\${empty param.name}</span>
                <span class="value">${empty param.name}</span>
            </div>
            <div class="info-row">
                <span class="label">\${param.name == null}</span>
                <span class="value">${param.name == null}</span>
            </div>
        </div>

        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
