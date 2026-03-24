<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ch07 - 时间刷新演示</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: #f0f0f0;
        }
        .container {
            text-align: center;
        }
        a {
            display: inline-block;
            padding: 15px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
        }
        a:hover {
            background: #5a6fd6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Ch07 - 时间刷新演示</h1>
        <a href="${pageContext.request.contextPath}/refresh">进入刷新页面</a>
    </div>
</body>
</html>
