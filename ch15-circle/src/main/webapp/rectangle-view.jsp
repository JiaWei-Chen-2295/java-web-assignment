<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fun.javierchen.ch15circle.Rectangle" %>
<%
    Rectangle rectangle = (Rectangle) request.getAttribute("rectangle");

    if (rectangle == null) {
        response.sendRedirect("rectangle-form.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>矩形计算器 - 计算结果</title>
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
            width: 460px;
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
            margin-bottom: 28px;
            background: linear-gradient(135deg, #f472b6, #fb923c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .visual {
            text-align: center;
            margin-bottom: 28px;
        }

        .visual svg rect {
            animation: drawRect 0.8s ease-out forwards;
        }

        @keyframes drawRect {
            from { stroke-dashoffset: 320; }
            to { stroke-dashoffset: 0; }
        }

        .dim-label {
            font-size: 14px;
            color: #f9a8d4;
            margin-top: 8px;
        }

        .result-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 28px;
        }

        .result-item {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideIn 0.4s ease-out backwards;
        }

        .result-item:nth-child(1) { animation-delay: 0.1s; }
        .result-item:nth-child(2) { animation-delay: 0.2s; }
        .result-item:nth-child(3) { animation-delay: 0.3s; }
        .result-item:nth-child(4) { animation-delay: 0.4s; }

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
            background: linear-gradient(135deg, rgba(236, 72, 153, 0.12), rgba(249, 115, 22, 0.12));
            border-color: rgba(244, 114, 182, 0.2);
        }

        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .btn-back {
            display: block;
            padding: 14px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            color: #fff;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-back.primary {
            background: linear-gradient(135deg, #ec4899, #f97316);
        }

        .btn-back.secondary {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .btn-back:hover {
            transform: translateY(-2px);
        }

        .btn-back.primary:hover {
            box-shadow: 0 8px 25px rgba(236, 72, 153, 0.4);
        }

        .btn-back.secondary:hover {
            box-shadow: 0 8px 25px rgba(167, 139, 250, 0.2);
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>计算结果</h1>

        <div class="visual">
            <svg width="160" height="110" viewBox="0 0 160 110">
                <rect x="10" y="10" width="140" height="90" rx="4"
                      fill="rgba(244, 114, 182, 0.06)"
                      stroke="url(#rectResultGrad)" stroke-width="2.5"
                      stroke-dasharray="320" stroke-dashoffset="320"/>
                <!-- length arrow -->
                <line x1="10" y1="105" x2="150" y2="105"
                      stroke="#f9a8d4" stroke-width="1" marker-end="url(#arrow)"/>
                <text x="80" y="103" text-anchor="middle" fill="#f9a8d4" font-size="11">L</text>
                <!-- width arrow -->
                <line x1="155" y1="10" x2="155" y2="100"
                      stroke="#fdba74" stroke-width="1" marker-end="url(#arrow)"/>
                <text x="153" y="58" text-anchor="middle" fill="#fdba74" font-size="11"
                      transform="rotate(90,153,58)">W</text>
                <defs>
                    <linearGradient id="rectResultGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" style="stop-color:#f472b6"/>
                        <stop offset="100%" style="stop-color:#fb923c"/>
                    </linearGradient>
                    <marker id="arrow" markerWidth="6" markerHeight="6"
                            refX="5" refY="3" orient="auto">
                        <path d="M0,0 L6,3 L0,6" fill="none" stroke="#9ca3af" stroke-width="1"/>
                    </marker>
                </defs>
            </svg>
            <div class="dim-label">L = <%= String.format("%.2f", rectangle.getLength()) %>  |  W = <%= String.format("%.2f", rectangle.getWidth()) %></div>
        </div>

        <ul class="result-list">
            <li class="result-item">
                <div class="label">
                    长度
                    <span class="formula">L</span>
                </div>
                <div class="value">
                    <%= String.format("%.2f", rectangle.getLength()) %>
                    <span class="unit">单位</span>
                </div>
            </li>
            <li class="result-item">
                <div class="label">
                    宽度
                    <span class="formula">W</span>
                </div>
                <div class="value">
                    <%= String.format("%.2f", rectangle.getWidth()) %>
                    <span class="unit">单位</span>
                </div>
            </li>
            <li class="result-item highlight">
                <div class="label">
                    周长
                    <span class="formula">C = 2(L + W)</span>
                </div>
                <div class="value">
                    <%= String.format("%.4f", rectangle.getPerimeter()) %>
                    <span class="unit">单位</span>
                </div>
            </li>
            <li class="result-item highlight">
                <div class="label">
                    面积
                    <span class="formula">S = L x W</span>
                </div>
                <div class="value">
                    <%= String.format("%.4f", rectangle.getArea()) %>
                    <span class="unit">平方单位</span>
                </div>
            </li>
        </ul>

        <div class="btn-group">
            <a href="rectangle-form.jsp" class="btn-back primary">重新计算</a>
            <a href="circle-form.jsp" class="btn-back secondary">圆计算器</a>
        </div>
    </div>
</body>
</html>
