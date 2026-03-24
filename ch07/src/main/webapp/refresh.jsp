<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Time Refresh</title>
    <meta http-equiv="refresh" content="3">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            min-height: 100vh;
            background: #fafafa;
            font-family: 'Courier New', monospace;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            border: 2px solid #222;
            padding: 32px 48px;
            position: relative;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 8px;
            left: 8px;
            right: -8px;
            bottom: -8px;
            border: 2px solid #222;
            z-index: -1;
        }
        .row {
            display: flex;
            gap: 24px;
            margin-bottom: 24px;
            font-size: 15px;
        }
        .row span:first-child {
            color: #888;
        }
        .time-display {
            font-size: 28px;
            letter-spacing: 2px;
            padding: 16px 0;
            border-top: 1px dashed #ccc;
            text-align: center;
        }
        .dot {
            display: inline-block;
            width: 6px;
            height: 6px;
            background: #4ade80;
            border-radius: 50%;
            margin-right: 8px;
            animation: blink 1s infinite;
        }
        @keyframes blink {
            50% { opacity: 0.3; }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="row">
            <span>ID</span>
            <span>${studentId}</span>
        </div>
        <div class="row">
            <span>NAME</span>
            <span>${studentName}</span>
        </div>
        <div class="time-display">
            <span class="dot"></span>${currentTime}
        </div>
    </div>
</body>
</html>
