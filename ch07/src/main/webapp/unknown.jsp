<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Unknown Browser</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            background: #f5f5f5;
            font-family: monospace;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        pre {
            background: #fff;
            border: 1px solid #ddd;
            padding: 24px 32px;
            font-size: 14px;
            line-height: 1.8;
        }
        .key { color: #888; }
        .val { color: #333; }
    </style>
</head>
<body>
    <pre><span class="key">browser:</span> <span class="val">unknown</span>
<span class="key">ua:</span> <span class="val"><%= request.getHeader("User-Agent") %></span></pre>
</body>
</html>
