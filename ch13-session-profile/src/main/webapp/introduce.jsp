<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关于我们 — Session Profile</title>
    <style>
        :root {
            --apple-blue: #007AFF;
            --apple-blue-hover: #0063D1;
            --apple-gray: #86868B;
            --apple-bg: #F5F5F7;
            --apple-surface: #FFFFFF;
            --apple-text: #1D1D1F;
            --apple-text-secondary: #6E6E73;
            --apple-radius: 18px;
            --apple-radius-sm: 12px;
            --apple-shadow: 0 2px 12px rgba(0,0,0,0.08);
            --apple-shadow-lg: 0 8px 40px rgba(0,0,0,0.12);
            --apple-font: -apple-system, BlinkMacSystemFont, 'SF Pro Display',
                          'SF Pro Text', 'Helvetica Neue', 'Microsoft YaHei', sans-serif;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--apple-font);
            background: var(--apple-bg);
            color: var(--apple-text);
            padding-top: 52px;
            min-height: 100vh;
        }

        /* Hero */
        .intro-hero {
            background: linear-gradient(180deg, #FFFFFF 0%, var(--apple-bg) 100%);
            padding: 80px 40px 60px;
            text-align: center;
        }
        .intro-hero .tag {
            display: inline-block;
            font-size: 14px;
            font-weight: 500;
            color: var(--apple-blue);
            background: rgba(0,122,255,0.08);
            padding: 6px 16px;
            border-radius: 980px;
            margin-bottom: 20px;
        }
        .intro-hero h1 {
            font-size: 52px;
            font-weight: 700;
            letter-spacing: -2px;
            color: var(--apple-text);
            line-height: 1.1;
        }
        .intro-hero h1 span {
            background: linear-gradient(90deg, var(--apple-blue), #5856D6, #FF375F);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .intro-hero p {
            font-size: 19px;
            color: var(--apple-text-secondary);
            max-width: 600px;
            margin: 16px auto 0;
            line-height: 1.6;
            letter-spacing: -0.2px;
        }

        /* Content */
        .intro-content {
            max-width: 900px;
            margin: 0 auto 80px;
            padding: 0 20px;
        }

        /* Feature Grid */
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 48px;
        }
        .feature-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 36px 28px;
            text-align: center;
            transition: transform 0.3s ease;
            animation: fadeUp 0.5s ease-out;
        }
        .feature-card:hover {
            transform: translateY(-4px);
        }
        .feature-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 16px;
        }
        .feature-icon.blue { background: rgba(0,122,255,0.1); }
        .feature-icon.purple { background: rgba(88,86,214,0.1); }
        .feature-icon.green { background: rgba(52,199,89,0.1); }
        .feature-card h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: -0.3px;
        }
        .feature-card p {
            font-size: 14px;
            color: var(--apple-text-secondary);
            line-height: 1.6;
        }

        /* About Section */
        .about-section {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 48px;
            margin-bottom: 32px;
            animation: fadeUp 0.5s ease-out 0.2s both;
        }
        .about-section h2 {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 20px;
        }
        .about-section p {
            font-size: 16px;
            color: var(--apple-text-secondary);
            line-height: 1.8;
            margin-bottom: 12px;
        }

        /* Tech Stack */
        .tech-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 24px;
        }
        .tech-item {
            background: var(--apple-bg);
            border-radius: var(--apple-radius-sm);
            padding: 20px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            color: var(--apple-text);
        }
        .tech-item .tech-name {
            font-size: 12px;
            color: var(--apple-gray);
            margin-top: 4px;
        }

        /* Team */
        .team-section {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 48px;
            animation: fadeUp 0.5s ease-out 0.3s both;
        }
        .team-section h2 {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 24px;
        }
        .team-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .team-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px;
            background: var(--apple-bg);
            border-radius: var(--apple-radius-sm);
        }
        .team-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #fff;
            font-weight: 600;
            flex-shrink: 0;
        }
        .team-avatar.a { background: linear-gradient(135deg, var(--apple-blue), #5856D6); }
        .team-avatar.b { background: linear-gradient(135deg, #FF375F, #FF6482); }
        .team-avatar.c { background: linear-gradient(135deg, #34C759, #30D158); }
        .team-avatar.d { background: linear-gradient(135deg, #FF9F0A, #FFB340); }
        .team-info h4 {
            font-size: 16px;
            font-weight: 600;
        }
        .team-info p {
            font-size: 13px;
            color: var(--apple-gray);
            margin-top: 2px;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 768px) {
            .intro-hero h1 { font-size: 36px; }
            .feature-grid { grid-template-columns: 1fr; }
            .tech-grid { grid-template-columns: repeat(2, 1fr); }
            .team-grid { grid-template-columns: 1fr; }
            .about-section, .team-section { padding: 32px 24px; }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="intro-hero">
    <div class="tag">Session Profile</div>
    <h1>用 <span>Session</span> 构建<br>安全的用户身份验证</h1>
    <p>一个基于 Jakarta Servlet 的 Session 身份验证系统，采用 Apple Design 设计语言，提供简洁优雅的用户体验。</p>
</div>

<div class="intro-content">
    <div class="feature-grid">
        <div class="feature-card">
            <div class="feature-icon blue">&#128274;</div>
            <h3>Session 验证</h3>
            <p>基于服务器端 Session 的身份认证，安全可靠，无需依赖第三方库</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon purple">&#128248;</div>
            <h3>验证码防护</h3>
            <p>动态生成的图形验证码，包含干扰线和旋转字符，有效防止机器人攻击</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon green">&#127912;</div>
            <h3>Apple Design</h3>
            <p>采用 Apple 设计语言，大量留白、柔和阴影、圆角卡片，视觉体验优雅</p>
        </div>
    </div>

    <div class="about-section">
        <h2>关于本项目</h2>
        <p>Session Profile 是一个 Java Web 实验项目，演示了如何使用 HttpSession 实现用户身份验证、页面访问控制和验证码功能。</p>
        <p>项目采用 Jakarta Servlet 6.0 规范，前端使用纯 JSP + CSS 实现，不依赖任何外部 UI 框架，所有样式均以内联方式编写。</p>

        <div class="tech-grid">
            <div class="tech-item">
                &#9749;
                <div class="tech-name">Jakarta Servlet 6.1</div>
            </div>
            <div class="tech-item">
                &#128196;
                <div class="tech-name">JSP 3.1</div>
            </div>
            <div class="tech-item">
                &#127912;
                <div class="tech-name">CSS3</div>
            </div>
            <div class="tech-item">
                &#128230;
                <div class="tech-name">Maven</div>
            </div>
        </div>
    </div>

    <div class="team-section">
        <h2>开发团队</h2>
        <div class="team-grid">
            <div class="team-card">
                <div class="team-avatar a">J</div>
                <div class="team-info">
                    <h4>Javier Chen</h4>
                    <p>全栈开发</p>
                </div>
            </div>
            <div class="team-card">
                <div class="team-avatar b">A</div>
                <div class="team-info">
                    <h4>AI Assistant</h4>
                    <p>Claude Code</p>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
