<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图形计算器</title>
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
            background: linear-gradient(135deg, #a78bfa, #60a5fa, #f472b6, #fb923c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            text-align: center;
            font-size: 14px;
            color: #9ca3af;
            margin-bottom: 36px;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px 24px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            text-decoration: none;
            color: #e0e0e0;
            transition: all 0.3s ease;
        }

        .menu a:hover {
            transform: translateY(-3px);
            background: rgba(255, 255, 255, 0.08);
        }

        .menu a.circle-link:hover {
            border-color: rgba(167, 139, 250, 0.3);
            box-shadow: 0 8px 25px rgba(167, 139, 250, 0.15);
        }

        .menu a.rect-link:hover {
            border-color: rgba(244, 114, 182, 0.3);
            box-shadow: 0 8px 25px rgba(244, 114, 182, 0.15);
        }

        .menu .icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .menu .icon.circle-bg {
            background: linear-gradient(135deg, rgba(167, 139, 250, 0.2), rgba(96, 165, 250, 0.2));
        }

        .menu .icon.rect-bg {
            background: linear-gradient(135deg, rgba(244, 114, 182, 0.2), rgba(251, 146, 60, 0.2));
        }

        .menu .text h2 {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 3px;
        }

        .menu .text p {
            font-size: 13px;
            color: #6b7280;
        }

        .menu a.circle-link .text h2 {
            color: #c4b5fd;
        }

        .menu a.rect-link .text h2 {
            color: #f9a8d4;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>图形计算器</h1>
        <p class="subtitle">选择要计算的图形</p>

        <div class="menu">
            <a href="circle-form.jsp" class="circle-link">
                <div class="icon circle-bg">
                    <svg width="28" height="28" viewBox="0 0 28 28">
                        <circle cx="14" cy="14" r="11" fill="none"
                                stroke="url(#cGrad)" stroke-width="2"/>
                        <defs>
                            <linearGradient id="cGrad">
                                <stop offset="0%" style="stop-color:#a78bfa"/>
                                <stop offset="100%" style="stop-color:#60a5fa"/>
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <div class="text">
                    <h2>圆</h2>
                    <p>输入半径，计算周长和面积</p>
                </div>
            </a>

            <a href="rectangle-form.jsp" class="rect-link">
                <div class="icon rect-bg">
                    <svg width="28" height="28" viewBox="0 0 28 28">
                        <rect x="3" y="6" width="22" height="16" rx="2" fill="none"
                              stroke="url(#rGrad)" stroke-width="2"/>
                        <defs>
                            <linearGradient id="rGrad">
                                <stop offset="0%" style="stop-color:#f472b6"/>
                                <stop offset="100%" style="stop-color:#fb923c"/>
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <div class="text">
                    <h2>矩形</h2>
                    <p>输入长和宽，计算周长和面积</p>
                </div>
            </a>
        </div>
    </div>
</body>
</html>
