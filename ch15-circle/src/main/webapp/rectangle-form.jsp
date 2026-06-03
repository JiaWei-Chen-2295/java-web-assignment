<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>矩形计算器 - 输入尺寸</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: #e0e0e0;
        }

        .card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 48px 40px;
            width: 420px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            animation: fadeUp 0.6s ease-out;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card h1 {
            text-align: center;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #f472b6, #fb923c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            text-align: center;
            font-size: 14px;
            color: #9ca3af;
            margin-bottom: 32px;
        }

        .shape-icon {
            text-align: center;
            margin-bottom: 20px;
        }

        .shape-icon svg rect {
            animation: drawRect 0.8s ease-out forwards;
        }

        @keyframes drawRect {
            from { stroke-dashoffset: 320; }
            to { stroke-dashoffset: 0; }
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #f9a8d4;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            font-size: 18px;
            color: #fff;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #f472b6;
            box-shadow: 0 0 0 3px rgba(244, 114, 182, 0.2);
            background: rgba(255, 255, 255, 0.12);
        }

        .form-group input::placeholder {
            color: #6b7280;
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #ec4899, #f97316);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 1px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(236, 72, 153, 0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .error-msg {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            color: #fca5a5;
            font-size: 14px;
            text-align: center;
        }

        .nav-link {
            text-align: center;
            margin-top: 16px;
        }

        .nav-link a {
            color: #9ca3af;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.3s;
        }

        .nav-link a:hover {
            color: #f472b6;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="shape-icon">
            <svg width="100" height="70" viewBox="0 0 100 70">
                <rect x="5" y="5" width="90" height="60" rx="4" fill="none"
                      stroke="url(#rectGrad)" stroke-width="2.5"
                      stroke-dasharray="320" stroke-dashoffset="320"/>
                <text x="50" y="38" text-anchor="middle" fill="#f9a8d4"
                      font-size="12" font-weight="600">L x W</text>
                <defs>
                    <linearGradient id="rectGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" style="stop-color:#f472b6"/>
                        <stop offset="100%" style="stop-color:#fb923c"/>
                    </linearGradient>
                </defs>
            </svg>
        </div>
        <h1>矩形计算器</h1>
        <p class="subtitle">输入长和宽，计算周长和面积</p>

        <% if (error != null) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="rectangle" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="length">长度 (L)</label>
                    <input type="number" id="length" name="length" step="any" min="0.01"
                           placeholder="长度" required autofocus>
                </div>
                <div class="form-group">
                    <label for="width">宽度 (W)</label>
                    <input type="number" id="width" name="width" step="any" min="0.01"
                           placeholder="宽度" required>
                </div>
            </div>
            <button type="submit" class="btn">计算</button>
        </form>

        <div class="nav-link">
            <a href="circle-form.jsp">切换到圆计算器</a>
        </div>
    </div>
</body>
</html>
