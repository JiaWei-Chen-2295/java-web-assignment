<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL 三目运算符</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 520px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 28px; font-size: 24px; }
        .demo-box {
            background: #f0fff4; border-radius: 10px; padding: 20px;
            margin-bottom: 20px; border: 1px solid #c8e6c9;
        }
        .demo-box h3 { color: #2e7d32; margin-bottom: 12px; font-size: 15px; }
        .result { padding: 10px 0; font-size: 15px; color: #333; }
        .expr { font-family: "Consolas", monospace; color: #00695c; background: #e0f2f1; padding: 2px 8px; border-radius: 4px; }
        .links { margin-top: 24px; text-align: center; }
        .links a {
            display: inline-block; margin: 6px; padding: 10px 20px;
            background: #43e97b; color: #fff; border-radius: 8px;
            text-decoration: none; font-size: 14px; transition: opacity 0.2s;
        }
        .links a:hover { opacity: 0.85; }
        .back { display: block; text-align: center; margin-top: 20px; color: #2e7d32; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL 三目运算符</h1>

        <div class="demo-box">
            <h3>根据 sex 参数判断性别</h3>
            <p style="font-size:13px;color:#666;margin-bottom:12px;">
                点击下方链接测试，或在地址栏手动添加 <code>?sex=男</code> 或 <code>?sex=女</code>
            </p>
            <div class="result">
                当前 sex 参数: <strong>${param.sex}</strong>
            </div>
            <div class="result">
                判断结果: <strong>
                    ${param.sex == null ? "未指定" : (param.sex == "男" ? "男性" : (param.sex == "女" ? "女性" : "未知"))}
                </strong>
            </div>
            <div class="result">
                使用 empty 判断: <span class="expr">${empty param.sex ? "请传入sex参数" : param.sex}</span>
            </div>
        </div>

        <div class="demo-box">
            <h3>其他三目运算示例</h3>
            <div class="result">
                <span class="expr">\${10 > 5 ? "大于" : "小于"}</span> → ${10 > 5 ? "大于" : "小于"}
            </div>
            <div class="result">
                <span class="expr">\${empty param.name ? "匿名用户" : param.name}</span> → ${empty param.name ? "匿名用户" : param.name}
            </div>
            <div class="result">
                <span class="expr">\${param.age >= 18 ? "成年" : "未成年"}</span> → ${param.age >= 18 ? "成年" : "未成年"}
            </div>
        </div>

        <div class="links">
            <a href="three.jsp?sex=男">sex=男</a>
            <a href="three.jsp?sex=女">sex=女</a>
            <a href="three.jsp">不传sex</a>
        </div>

        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
