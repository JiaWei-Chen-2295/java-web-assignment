<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login-session.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>领养中心 — Session Profile</title>
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
        .foster-hero {
            background: linear-gradient(135deg, #0f3460 0%, #16213e 50%, #1a1a2e 100%);
            padding: 60px 40px 50px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .foster-hero::after {
            content: '';
            position: absolute;
            top: -30%;
            right: -20%;
            width: 60%;
            height: 160%;
            background: radial-gradient(ellipse, rgba(0,122,255,0.12) 0%, transparent 70%);
            pointer-events: none;
        }
        .foster-hero h1 {
            font-size: 40px;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -1px;
            position: relative;
            z-index: 1;
        }
        .foster-hero p {
            font-size: 17px;
            color: rgba(255,255,255,0.65);
            margin-top: 10px;
            position: relative;
            z-index: 1;
        }

        /* Content */
        .foster-content {
            max-width: 960px;
            margin: -20px auto 60px;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }

        /* Stats */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }
        .stat-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            padding: 28px;
            text-align: center;
            animation: fadeUp 0.5s ease-out;
        }
        .stat-card .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: var(--apple-blue);
            letter-spacing: -1px;
        }
        .stat-card .stat-label {
            font-size: 13px;
            color: var(--apple-gray);
            margin-top: 4px;
            font-weight: 500;
        }

        /* Pet Grid */
        .pet-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .pet-card {
            background: var(--apple-surface);
            border-radius: var(--apple-radius);
            box-shadow: var(--apple-shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeUp 0.5s ease-out;
        }
        .pet-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--apple-shadow-lg);
        }
        .pet-image {
            width: 100%;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 72px;
        }
        .pet-image.cat { background: linear-gradient(135deg, #FFE5B4, #FFD699); }
        .pet-image.dog { background: linear-gradient(135deg, #B4D8E7, #8EC5E0); }
        .pet-image.rabbit { background: linear-gradient(135deg, #E8D5F5, #D4B8E8); }
        .pet-image.hamster { background: linear-gradient(135deg, #C8E6C9, #A5D6A7); }
        .pet-image.bird { background: linear-gradient(135deg, #FFF9C4, #FFF176); }
        .pet-image.fish { background: linear-gradient(135deg, #B3E5FC, #81D4FA); }
        .pet-body {
            padding: 20px;
        }
        .pet-body h3 {
            font-size: 18px;
            font-weight: 600;
            letter-spacing: -0.3px;
        }
        .pet-body .pet-desc {
            font-size: 14px;
            color: var(--apple-text-secondary);
            margin-top: 6px;
            line-height: 1.5;
        }
        .pet-body .pet-meta {
            display: flex;
            gap: 12px;
            margin-top: 12px;
        }
        .pet-tag {
            font-size: 11px;
            font-weight: 500;
            padding: 4px 10px;
            border-radius: 980px;
            background: var(--apple-bg);
            color: var(--apple-text-secondary);
        }
        .pet-tag.age { background: rgba(0,122,255,0.08); color: var(--apple-blue); }
        .pet-tag.gender { background: rgba(255,59,48,0.08); color: #FF3B30; }

        .btn-adopt {
            display: block;
            width: calc(100% - 40px);
            margin: 0 20px 20px;
            height: 40px;
            font-size: 14px;
            font-weight: 500;
            font-family: var(--apple-font);
            color: var(--apple-blue);
            background: rgba(0,122,255,0.08);
            border: none;
            border-radius: 980px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-adopt:hover {
            background: var(--apple-blue);
            color: #fff;
        }

        @media (max-width: 768px) {
            .stats-row {
                grid-template-columns: 1fr;
            }
            .pet-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="foster-hero">
    <h1>领养中心</h1>
    <p>给每一个小生命一个温暖的家</p>
</div>

<div class="foster-content">
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-number">128</div>
            <div class="stat-label">待领养动物</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">1,024</div>
            <div class="stat-label">已成功领养</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">98%</div>
            <div class="stat-label">满意度</div>
        </div>
    </div>

    <div class="pet-grid">
        <div class="pet-card">
            <div class="pet-image cat">&#128049;</div>
            <div class="pet-body">
                <h3>橘子</h3>
                <div class="pet-desc">性格温顺的橘猫，喜欢趴在窗台晒太阳，非常亲人</div>
                <div class="pet-meta">
                    <span class="pet-tag age">2岁</span>
                    <span class="pet-tag gender">公</span>
                    <span class="pet-tag">已绝育</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>

        <div class="pet-card">
            <div class="pet-image dog">&#128054;</div>
            <div class="pet-body">
                <h3>旺财</h3>
                <div class="pet-desc">活泼好动的金毛寻回犬，对小朋友特别友好</div>
                <div class="pet-meta">
                    <span class="pet-tag age">1岁</span>
                    <span class="pet-tag gender">公</span>
                    <span class="pet-tag">已疫苗</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>

        <div class="pet-card">
            <div class="pet-image rabbit">&#128048;</div>
            <div class="pet-body">
                <h3>雪球</h3>
                <div class="pet-desc">纯白色垂耳兔，安静乖巧，适合公寓饲养</div>
                <div class="pet-meta">
                    <span class="pet-tag age">8个月</span>
                    <span class="pet-tag gender">母</span>
                    <span class="pet-tag">已驱虫</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>

        <div class="pet-card">
            <div class="pet-image bird">&#128038;</div>
            <div class="pet-body">
                <h3>小翠</h3>
                <div class="pet-desc">翠绿色虎皮鹦鹉，会说简单的词语，非常聪明</div>
                <div class="pet-meta">
                    <span class="pet-tag age">1岁</span>
                    <span class="pet-tag gender">母</span>
                    <span class="pet-tag">健康</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>

        <div class="pet-card">
            <div class="pet-image hamster">&#128057;</div>
            <div class="pet-body">
                <h3>团子</h3>
                <div class="pet-desc">仓鼠界的社交达人，喜欢在转轮上运动</div>
                <div class="pet-meta">
                    <span class="pet-tag age">6个月</span>
                    <span class="pet-tag gender">公</span>
                    <span class="pet-tag">已驱虫</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>

        <div class="pet-card">
            <div class="pet-image fish">&#128032;</div>
            <div class="pet-body">
                <h3>锦鲤</h3>
                <div class="pet-desc">一对色彩斑斓的锦鲤，为你的家增添好运</div>
                <div class="pet-meta">
                    <span class="pet-tag age">1岁</span>
                    <span class="pet-tag gender">一对</span>
                    <span class="pet-tag">健康</span>
                </div>
            </div>
            <button class="btn-adopt">申请领养</button>
        </div>
    </div>
</div>

</body>
</html>
