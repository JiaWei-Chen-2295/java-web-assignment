<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edge</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            background: #f3f3f3;
            font-family: 'Segoe UI', sans-serif;
        }
        .bar {
            height: 4px;
            background: linear-gradient(90deg, #0078d4 0%, #50e6ff 50%, #0078d4 100%);
        }
        main {
            padding: 80px 40px;
        }
        h1 {
            font-size: 48px;
            font-weight: 300;
            color: #0078d4;
            margin: 0 0 16px 0;
        }
        h1 span {
            font-weight: 600;
        }
        p {
            color: #666;
            font-size: 14px;
            margin: 0;
        }
        .badge {
            display: inline-block;
            margin-top: 32px;
            padding: 8px 16px;
            border: 1px solid #0078d4;
            color: #0078d4;
            font-size: 12px;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
    <div class="bar"></div>
    <main>
        <h1>Microsoft <span>Edge</span></h1>
        <p>User-Agent: <%= request.getHeader("User-Agent") %></p>
        <div class="badge">DETECTED</div>
    </main>
</body>
</html>
