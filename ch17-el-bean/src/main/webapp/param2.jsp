<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL 隐含对象 paramValues</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 580px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 28px; font-size: 24px; }
        .section {
            background: #e8f5e9; border-radius: 10px; padding: 20px;
            margin-bottom: 20px; border: 1px solid #c8e6c9;
        }
        .section h3 { color: #1b5e20; margin-bottom: 12px; font-size: 15px; }
        .info-row {
            display: flex; padding: 8px 0; border-bottom: 1px solid #e8f5e9;
            font-size: 14px;
        }
        .info-row:last-child { border-bottom: none; }
        .label { width: 200px; color: #888; font-family: "Consolas", monospace; }
        .value { color: #333; font-weight: 500; }
        .note {
            padding: 12px; background: #e3f2fd; border-radius: 8px;
            font-size: 13px; color: #0d47a1; margin-bottom: 20px;
        }
        .test-form {
            display: flex; flex-direction: column; gap: 12px;
            margin-bottom: 20px; padding: 20px; background: #f3e5f5;
            border-radius: 10px;
        }
        .form-row { display: flex; align-items: center; gap: 12px; }
        .form-row label { width: 80px; font-size: 14px; color: #555; }
        .form-row input[type="text"] {
            flex: 1; padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;
        }
        .checkboxes { display: flex; gap: 16px; }
        .checkboxes label { font-size: 14px; color: #555; cursor: pointer; }
        .form-row button {
            padding: 10px 24px; background: #7c4dff; color: #fff; border: none;
            border-radius: 8px; cursor: pointer; font-size: 14px;
        }
        .back { display: block; text-align: center; margin-top: 20px; color: #1b5e20; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL 隐含对象: paramValues</h1>

        <div class="note">
            \${paramValues.hobby[0]} 等价于 request.getParameterValues("hobby")[0]。
            当一个参数名对应多个值时（如复选框），使用 paramValues 获取数组。
        </div>

        <form class="test-form" method="get" action="param2.jsp">
            <div class="form-row">
                <label>姓名：</label>
                <input type="text" name="name" value="${param.name}" placeholder="输入姓名">
            </div>
            <div class="form-row">
                <label>爱好：</label>
                <div class="checkboxes">
                    <label><input type="checkbox" name="hobby" value="编程" ${paramValues.hobby[0] == '编程' || paramValues.hobby[1] == '编程' || paramValues.hobby[2] == '编程' || paramValues.hobby[3] == '编程' ? 'checked' : ''}> 编程</label>
                    <label><input type="checkbox" name="hobby" value="阅读" ${paramValues.hobby[0] == '阅读' || paramValues.hobby[1] == '阅读' || paramValues.hobby[2] == '阅读' || paramValues.hobby[3] == '阅读' ? 'checked' : ''}> 阅读</label>
                    <label><input type="checkbox" name="hobby" value="音乐" ${paramValues.hobby[0] == '音乐' || paramValues.hobby[1] == '音乐' || paramValues.hobby[2] == '音乐' || paramValues.hobby[3] == '音乐' ? 'checked' : ''}> 音乐</label>
                    <label><input type="checkbox" name="hobby" value="运动" ${paramValues.hobby[0] == '运动' || paramValues.hobby[1] == '运动' || paramValues.hobby[2] == '运动' || paramValues.hobby[3] == '运动' ? 'checked' : ''}> 运动</label>
                </div>
            </div>
            <div class="form-row">
                <button type="submit">提交</button>
            </div>
        </form>

        <div class="section">
            <h3>param - 获取单值</h3>
            <div class="info-row">
                <span class="label">\${param.name}</span>
                <span class="value">${param.name}</span>
            </div>
            <div class="info-row">
                <span class="label">\${param.hobby}</span>
                <span class="value">${param.hobby}</span>
            </div>
        </div>

        <div class="section">
            <h3>paramValues - 获取多值数组</h3>
            <div class="info-row">
                <span class="label">\${paramValues.hobby[0]}</span>
                <span class="value">${paramValues.hobby[0]}</span>
            </div>
            <div class="info-row">
                <span class="label">\${paramValues.hobby[1]}</span>
                <span class="value">${paramValues.hobby[1]}</span>
            </div>
            <div class="info-row">
                <span class="label">\${paramValues.hobby[2]}</span>
                <span class="value">${paramValues.hobby[2]}</span>
            </div>
            <div class="info-row">
                <span class="label">\${paramValues.hobby[3]}</span>
                <span class="value">${paramValues.hobby[3]}</span>
            </div>
        </div>

        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
