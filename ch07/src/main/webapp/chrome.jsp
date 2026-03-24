<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chrome</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            background: #fff;
            font-family: 'Google Sans', Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .wrap {
            text-align: center;
        }
        .ring {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: conic-gradient(#ea4335 0deg 90deg, #fbbc04 90deg 180deg, #34a853 180deg 270deg, #4285f4 270deg 360deg);
            margin: 0 auto 40px;
            position: relative;
        }
        .ring::after {
            content: '';
            position: absolute;
            top: 30px;
            left: 30px;
            width: 60px;
            height: 60px;
            background: #fff;
            border-radius: 50%;
        }
        h1 {
            font-size: 32px;
            font-weight: 400;
            color: #202124;
            margin: 0 0 8px 0;
        }
        code {
            display: block;
            margin-top: 24px;
            padding: 12px 20px;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 11px;
            color: #5f6368;
            max-width: 400px;
            word-break: break-all;
        }
    </style>
</head>
<body>
    <div class="wrap">
        <div class="ring"></div>
        <h1>Google Chrome</h1>
        <code><%= request.getHeader("User-Agent") %></code>
    </div>
</body>
</html>
