<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Firefox</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            background: #1c1b22;
            font-family: system-ui, sans-serif;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 0 60px;
        }
        .flame {
            font-size: 64px;
            margin-bottom: 20px;
        }
        h1 {
            font-size: 42px;
            font-weight: 700;
            margin: 0 0 8px 0;
            background: linear-gradient(90deg, #ff7139, #ff9400);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        p {
            color: #8f8f9d;
            font-size: 13px;
            margin: 0;
            max-width: 500px;
            line-height: 1.6;
            word-break: break-all;
        }
        .tag {
            display: inline-block;
            margin-top: 24px;
            padding: 6px 12px;
            background: rgba(255, 113, 57, 0.15);
            color: #ff7139;
            font-size: 11px;
            border-radius: 4px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
    <div class="flame">🦊</div>
    <h1>Firefox</h1>
    <p><%= request.getHeader("User-Agent") %></p>
    <span class="tag">Browser Detected</span>
</body>
</html>
