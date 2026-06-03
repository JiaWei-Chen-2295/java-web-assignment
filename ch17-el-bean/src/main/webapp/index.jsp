<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EL表达式实验</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 48px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 40px;
            font-size: 28px;
        }
        .card-list { display: flex; flex-direction: column; gap: 16px; }
        .card {
            display: block;
            padding: 20px 24px;
            background: #f8f9ff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            text-decoration: none;
            color: #333;
            transition: all 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.2);
            border-color: #667eea;
        }
        .card h3 { color: #667eea; margin-bottom: 6px; }
        .card p { color: #666; font-size: 14px; }
        .section-title {
            color: #555; font-size: 13px; text-transform: uppercase;
            letter-spacing: 2px; margin: 24px 0 8px; padding-bottom: 6px;
            border-bottom: 1px solid #e0e0e0;
        }
        .section-title:first-child { margin-top: 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>EL表达式实验作业</h1>
        <div class="card-list">
            <div class="section-title">作业</div>
            <a class="card" href="${pageContext.request.contextPath}/employee">
                <h3>作业一：Java Bean 展示</h3>
                <p>Address 地址类 + Employee 客户类，使用 EL 表达式显示所有属性</p>
            </a>
            <a class="card" href="${pageContext.request.contextPath}/variables">
                <h3>作业二：作用域变量</h3>
                <p>VariableServlet 设置不同作用域对象，EL 表达式访问 page/request/session/application 作用域</p>
            </a>
            <a class="card" href="login.jsp">
                <h3>作业三：Session 登录</h3>
                <p>使用会话对象保存用户名密码，EL 表达式访问会话信息</p>
            </a>

            <div class="section-title">EL 运算符与隐含对象 (8.4.3)</div>
            <a class="card" href="empty.jsp">
                <h3>empty 运算符</h3>
                <p>判断 null、空字符串、空数组、空集合、空 Map</p>
            </a>
            <a class="card" href="three.jsp">
                <h3>三目运算符</h3>
                <p>根据 sex 参数判断性别，结合 empty 运算符使用</p>
            </a>
            <a class="card" href="param.jsp">
                <h3>隐含对象 param</h3>
                <p>EL 隐含对象 param 获取单个请求参数</p>
            </a>
            <a class="card" href="param2.jsp">
                <h3>隐含对象 paramValues</h3>
                <p>EL 隐含对象 paramValues 获取多值参数（复选框）</p>
            </a>
            <a class="card" href="${pageContext.request.contextPath}/header">
                <h3>隐含对象 header & cookie</h3>
                <p>EL 隐含对象 header 获取请求头，cookie 获取 Cookie 值</p>
            </a>

            <div class="section-title">JSTL 核心标签库 (8.5.2)</div>
            <a class="card" href="${pageContext.request.contextPath}/bigCities">
                <h3>&lt;c:forEach&gt; 迭代 Map</h3>
                <p>使用 JSTL 标签遍历 Map&lt;String,String&gt; 和 Map&lt;String,String[]&gt; 对象</p>
            </a>
        </div>
    </div>
</body>
</html>
