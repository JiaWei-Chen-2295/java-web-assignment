<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Double radius = (Double) request.getAttribute("radius");
    Double perimeter = (Double) request.getAttribute("perimeter");
    Double area = (Double) request.getAttribute("area");

    if (radius == null) {
        response.sendRedirect("circle-form.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>圆计算器 - 计算结果</title>
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
            width: 440px;
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
            margin-bottom: 32px;
            background: linear-gradient(135deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .visual {
            text-align: center;
            margin-bottom: 32px;
        }

        .visual svg circle {
            animation: drawCircle 1s ease-out forwards;
        }

        @keyframes drawCircle {
            from { stroke-dashoffset: 314; }
            to { stroke-dashoffset: 0; }
        }

        .visual .r-label {
            font-size: 18px;
            color: #a78bfa;
            font-weight: 600;
            margin-top: 8px;
        }

        .result-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
            margin-bottom: 32px;
        }

        .result-item {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideIn 0.4s ease-out backwards;
        }

        .result-item:nth-child(1) { animation-delay: 0.1s; }
        .result-item:nth-child(2) { animation-delay: 0.25s; }
        .result-item:nth-child(3) { animation-delay: 0.4s; }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .result-item .label {
            font-size: 14px;
            color: #9ca3af;
            font-weight: 500;
        }

        .result-item .label .formula {
            font-size: 12px;
            color: #6b7280;
            display: block;
            margin-top: 2px;
        }

        .result-item .value {
            font-size: 20px;
            font-weight: 700;
            color: #fff;
        }

        .result-item .value .unit {
            font-size: 13px;
            font-weight: 400;
            color: #9ca3af;
            margin-left: 4px;
        }

        .result-item.highlight {
            background: linear-gradient(135deg, rgba(124, 58, 237, 0.15), rgba(59, 130, 246, 0.15));
            border-color: rgba(167, 139, 250, 0.2);
        }

        .btn-back {
            display: block;
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #7c3aed, #3b82f6);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s ease;
            letter-spacing: 1px;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(124, 58, 237, 0.4);
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>计算结果</h1>

        <div class="visual">
            <svg width="120" height="120" viewBox="0 0 120 120">
                <circle cx="60" cy="60" r="50" fill="rgba(167, 139, 250, 0.08)"
                        stroke="url(#resultGrad)" stroke-width="2.5"
                        stroke-dasharray="314" stroke-dashoffset="314"/>
                <line x1="60" y1="60" x2="110" y2="60" stroke="#60a5fa" stroke-width="1.5" stroke-dasharray="4 3"/>
                <circle cx="60" cy="60" r="3" fill="#a78bfa"/>
                <defs>
                    <linearGradient id="resultGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" style="stop-color:#a78bfa"/>
                        <stop offset="100%" style="stop-color:#60a5fa"/>
                    </linearGradient>
                </defs>
            </svg>
            <div class="r-label">r = <%= String.format("%.2f", radius) %></div>
        </div>

        <ul class="result-list">
            <li class="result-item">
                <div class="label">
                    半径
                    <span class="formula">r</span>
                </div>
                <div class="value">
                    <%= String.format("%.2f", radius) %>
                    <span class="unit">单位</span>
                </div>
            </li>
            <li class="result-item highlight">
                <div class="label">
                    周长
                    <span class="formula">C = 2&pi;r</span>
                </div>
                <div class="value">
                    <%= String.format("%.4f", perimeter) %>
                    <span class="unit">单位</span>
                </div>
            </li>
            <li class="result-item highlight">
                <div class="label">
                    面积
                    <span class="formula">S = &pi;r&sup2;</span>
                </div>
                <div class="value">
                    <%= String.format("%.4f", area) %>
                    <span class="unit">平方单位</span>
                </div>
            </li>
        </ul>

        <a href="circle-form.jsp" class="btn-back">重新计算</a>
    </div>
</body>
</html>
