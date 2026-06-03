<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fun.javierchen.ch12cart.model.CartItem" %>
<%@ page import="fun.javierchen.ch12cart.model.Product" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    Collection<CartItem> directItems = (Collection<CartItem>) request.getAttribute("directItems");
    Collection<CartItem> redirectItems = (Collection<CartItem>) request.getAttribute("redirectItems");
    Collection<CartItem> guardItems = (Collection<CartItem>) request.getAttribute("guardItems");
    Map<String, String> guardTokens = (Map<String, String>) request.getAttribute("guardFormTokens");

    Integer directCount = (Integer) request.getAttribute("directCount");
    Integer redirectCount = (Integer) request.getAttribute("redirectCount");
    Integer guardCount = (Integer) request.getAttribute("guardCount");
    Integer directTotal = (Integer) request.getAttribute("directTotal");
    Integer redirectTotal = (Integer) request.getAttribute("redirectTotal");
    Integer guardTotal = (Integer) request.getAttribute("guardTotal");

    String directNotice = (String) request.getAttribute("directNotice");
    String redirectNotice = (String) request.getAttribute("redirectNotice");
    String guardNotice = (String) request.getAttribute("guardNotice");
    String activeTab = (String) request.getAttribute("activeTab");
    String sessionId = (String) request.getAttribute("sessionId");
    String base = request.getContextPath();
%>
<%!
    private String money(int amount) {
        return "NT$ " + String.format(Locale.US, "%,d", amount);
    }

    private String activeClass(String activeTab, String tab) {
        if (activeTab == null || activeTab.isBlank()) {
            return "direct".equals(tab) ? "is-active" : "";
        }
        return tab.equals(activeTab) ? "is-active" : "";
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session 购物车实验室</title>
    <style>
        :root {
            --bg: #f4f0e8;
            --surface: #fffaf1;
            --surface-strong: #ffffff;
            --ink: #111111;
            --muted: #6d675e;
            --line: rgba(17, 17, 17, 0.12);
            --shadow: 0 18px 52px rgba(17, 17, 17, 0.1);
            --hero: linear-gradient(135deg, #121212 0%, #202020 55%, #4c1f1f 100%);
            --accent: #cc2f2f;
            --accent-soft: #ffe3dc;
            --pill: #efe5d4;
            --mono: linear-gradient(135deg, #090909, #505050);
            --sand: linear-gradient(135deg, #e3d6bf, #bca37d);
            --red: linear-gradient(135deg, #4e0909, #d64646);
            --ink-tone: linear-gradient(135deg, #1b2431, #475161);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            color: var(--ink);
            background:
                    radial-gradient(circle at top left, rgba(204, 47, 47, 0.08), transparent 28%),
                    linear-gradient(180deg, #f7f2e9 0%, #efe5d7 100%);
            font-family: "Avenir Next Condensed", "Arial Narrow", "PingFang SC", "Microsoft YaHei", sans-serif;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .topbar {
            padding: 12px 24px;
            background: #0f0f0f;
            color: #f6eede;
            font-size: 12px;
            letter-spacing: 0.28em;
            text-transform: uppercase;
            text-align: center;
        }

        .shell {
            width: min(1380px, calc(100% - 32px));
            margin: 0 auto 56px;
        }

        .masthead {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            padding: 24px 0 14px;
        }

        .brandmark {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .brand-block {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: #101010;
            color: #f8f0de;
            display: grid;
            place-items: center;
            font-size: 24px;
            font-weight: 700;
            box-shadow: var(--shadow);
        }

        .brand-text h1,
        .hero-copy h2,
        .lab-title,
        .product-name,
        .cart-panel h4 {
            margin: 0;
            font-family: Impact, Haettenschweiler, "Arial Narrow Bold", sans-serif;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .brand-text h1 {
            font-size: 34px;
            line-height: 0.95;
        }

        .brand-text span {
            display: block;
            color: var(--muted);
            font-size: 12px;
            letter-spacing: 0.18em;
            text-transform: uppercase;
        }

        .mast-nav {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .nav-pill {
            padding: 11px 16px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid rgba(17, 17, 17, 0.08);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.16em;
            text-transform: uppercase;
        }

        .hero {
            position: relative;
            overflow: hidden;
            background: var(--hero);
            border-radius: 28px;
            min-height: 360px;
            padding: 42px;
            color: #fff7e8;
            box-shadow: var(--shadow);
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 24px;
            align-items: end;
        }

        .hero::before,
        .hero::after {
            content: "";
            position: absolute;
            border-radius: 999px;
            filter: blur(8px);
            opacity: 0.6;
        }

        .hero::before {
            width: 320px;
            height: 320px;
            right: -60px;
            top: -80px;
            background: rgba(255, 255, 255, 0.1);
        }

        .hero::after {
            width: 240px;
            height: 240px;
            left: 45%;
            bottom: -120px;
            background: rgba(204, 47, 47, 0.22);
        }

        .hero-copy,
        .hero-stats {
            position: relative;
            z-index: 1;
        }

        .hero-copy small,
        .eyebrow,
        .section-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.08);
            font-size: 12px;
            letter-spacing: 0.16em;
            text-transform: uppercase;
        }

        .hero-copy h2 {
            margin-top: 18px;
            font-size: clamp(40px, 7vw, 82px);
            line-height: 0.92;
            max-width: 700px;
        }

        .hero-copy p {
            max-width: 560px;
            font-size: 17px;
            line-height: 1.7;
            color: rgba(255, 247, 232, 0.85);
        }

        .hero-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 22px;
        }

        .hero-badges span {
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 12px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }

        .hero-stats {
            display: grid;
            gap: 14px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 22px;
            padding: 18px 20px;
            backdrop-filter: blur(10px);
        }

        .stat-card strong {
            display: block;
            font-size: 13px;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: rgba(255, 247, 232, 0.8);
            margin-bottom: 10px;
        }

        .stat-card b {
            display: block;
            font-size: 30px;
            line-height: 1;
            margin-bottom: 8px;
        }

        .stat-card span {
            font-size: 14px;
            color: rgba(255, 247, 232, 0.72);
            line-height: 1.5;
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 20px;
            margin: 36px 0 18px;
        }

        .section-head h3 {
            margin: 10px 0 0;
            font-size: clamp(28px, 3vw, 42px);
            font-family: Impact, Haettenschweiler, "Arial Narrow Bold", sans-serif;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .section-head p {
            margin: 0;
            max-width: 580px;
            color: var(--muted);
            line-height: 1.7;
            font-size: 15px;
        }

        .jump-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .jump-link {
            padding: 12px 16px;
            border-radius: 18px;
            border: 1px solid rgba(17, 17, 17, 0.08);
            background: rgba(255, 255, 255, 0.75);
            min-width: 180px;
        }

        .jump-link strong,
        .jump-link span {
            display: block;
        }

        .jump-link strong {
            font-size: 13px;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .jump-link span {
            font-size: 13px;
            color: var(--muted);
        }

        .labs {
            display: grid;
            gap: 24px;
        }

        .lab {
            background: rgba(255, 250, 241, 0.82);
            border: 1px solid rgba(17, 17, 17, 0.08);
            border-radius: 28px;
            padding: 24px;
            box-shadow: 0 12px 32px rgba(17, 17, 17, 0.06);
            scroll-margin-top: 24px;
        }

        .lab.is-active {
            border-color: rgba(204, 47, 47, 0.45);
            box-shadow: 0 18px 40px rgba(204, 47, 47, 0.12);
        }

        .lab-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 18px;
        }

        .lab-title {
            font-size: clamp(26px, 2vw, 34px);
        }

        .lab-meta {
            color: var(--muted);
            font-size: 14px;
            max-width: 600px;
            line-height: 1.7;
        }

        .status-chip {
            padding: 9px 14px;
            border-radius: 999px;
            background: var(--pill);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.14em;
            text-transform: uppercase;
        }

        .notice {
            margin-bottom: 18px;
            padding: 16px 18px;
            border-radius: 18px;
            border: 1px solid rgba(204, 47, 47, 0.16);
            background: linear-gradient(135deg, rgba(255, 241, 233, 0.95), rgba(255, 252, 248, 0.95));
            color: #7c1f1f;
            line-height: 1.7;
            font-size: 14px;
        }

        .lab-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.65fr) minmax(320px, 0.95fr);
            gap: 22px;
            align-items: start;
        }

        .products {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .product-card {
            background: rgba(255, 255, 255, 0.85);
            border: 1px solid rgba(17, 17, 17, 0.08);
            border-radius: 24px;
            overflow: hidden;
            transform: translateY(0);
            transition: transform 0.24s ease, box-shadow 0.24s ease;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 32px rgba(17, 17, 17, 0.08);
        }

        .product-visual {
            min-height: 220px;
            padding: 18px;
            display: flex;
            justify-content: space-between;
            align-items: start;
            color: #fff7ea;
            position: relative;
        }

        .product-visual::after {
            content: "";
            position: absolute;
            right: 18px;
            bottom: 18px;
            width: 92px;
            height: 92px;
            border-radius: 26px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            background: rgba(255, 255, 255, 0.08);
        }

        .product-visual.mono { background: var(--mono); }
        .product-visual.sand { background: var(--sand); color: #23190b; }
        .product-visual.red { background: var(--red); }
        .product-visual.ink { background: var(--ink-tone); }

        .product-series,
        .product-badge {
            position: relative;
            z-index: 1;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.16em;
            text-transform: uppercase;
        }

        .product-badge {
            padding: 8px 10px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.16);
        }

        .product-body {
            padding: 18px;
        }

        .product-name {
            font-size: 28px;
            line-height: 0.94;
        }

        .product-subtitle {
            margin: 10px 0 16px;
            color: var(--muted);
            line-height: 1.6;
            min-height: 42px;
        }

        .product-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }

        .price {
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 0.04em;
        }

        .add-form {
            margin: 0;
        }

        .add-btn,
        .ghost-btn {
            appearance: none;
            border: none;
            border-radius: 16px;
            padding: 13px 16px;
            font-family: inherit;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            cursor: pointer;
            transition: transform 0.16s ease, opacity 0.16s ease;
        }

        .add-btn:hover,
        .ghost-btn:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .add-btn.direct {
            background: #111111;
            color: #fff8ec;
        }

        .add-btn.redirect {
            background: #d33a35;
            color: #fff8ec;
        }

        .add-btn.guard {
            background: #1b2431;
            color: #fff8ec;
        }

        .cart-panel {
            position: sticky;
            top: 18px;
            background: var(--surface-strong);
            border: 1px solid rgba(17, 17, 17, 0.08);
            border-radius: 24px;
            padding: 22px;
            box-shadow: 0 16px 36px rgba(17, 17, 17, 0.08);
        }

        .cart-panel h4 {
            font-size: 26px;
            margin-bottom: 6px;
        }

        .cart-panel p {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }

        .cart-summary {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin: 18px 0;
        }

        .summary-box {
            background: #fbf7ef;
            border-radius: 18px;
            padding: 14px;
            border: 1px solid rgba(17, 17, 17, 0.06);
        }

        .summary-box strong,
        .summary-box span {
            display: block;
        }

        .summary-box strong {
            font-size: 12px;
            color: var(--muted);
            letter-spacing: 0.12em;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .summary-box span {
            font-size: 22px;
            font-weight: 700;
        }

        .cart-list {
            display: grid;
            gap: 10px;
            margin-bottom: 18px;
        }

        .cart-line {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 10px;
            padding: 12px 14px;
            border-radius: 18px;
            background: #f8f2e7;
            border: 1px solid rgba(17, 17, 17, 0.06);
        }

        .cart-line strong,
        .cart-line span {
            display: block;
        }

        .cart-line strong {
            font-size: 15px;
        }

        .cart-line span {
            color: var(--muted);
            font-size: 13px;
            margin-top: 4px;
        }

        .cart-empty {
            padding: 18px;
            border-radius: 18px;
            background: #fbf6ee;
            color: var(--muted);
            border: 1px dashed rgba(17, 17, 17, 0.14);
            line-height: 1.7;
        }

        .panel-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .ghost-btn {
            background: #efe4d5;
            color: #241b12;
        }

        .ghost-btn.dark {
            background: #111111;
            color: #fff8ec;
        }

        .footnote {
            margin-top: 28px;
            padding: 24px 0 8px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.8;
        }

        .footnote strong {
            color: var(--ink);
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        @media (max-width: 1120px) {
            .hero,
            .lab-grid {
                grid-template-columns: 1fr;
            }

            .cart-panel {
                position: static;
            }
        }

        @media (max-width: 760px) {
            .shell {
                width: min(100% - 20px, 100%);
            }

            .masthead,
            .section-head,
            .lab-head {
                flex-direction: column;
                align-items: flex-start;
            }

            .hero {
                padding: 24px;
                min-height: auto;
            }

            .products {
                grid-template-columns: 1fr;
            }

            .product-row {
                flex-direction: column;
                align-items: stretch;
            }

            .add-btn,
            .ghost-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="topbar">Session Cart Demo Lab · Refresh / Redirect / Session Guard</div>

<div class="shell">
    <header class="masthead">
        <div class="brandmark">
            <div class="brand-block">S</div>
            <div class="brand-text">
                <h1>Session Cart Lab</h1>
                <span>Streetwear-inspired Java Web experiment</span>
            </div>
        </div>
        <nav class="mast-nav">
            <a class="nav-pill" href="#direct">01 Direct Post</a>
            <a class="nav-pill" href="#redirect">02 Redirect</a>
            <a class="nav-pill" href="#guard">03 Session Guard</a>
        </nav>
    </header>

    <section class="hero">
        <div class="hero-copy">
            <small>Inspired by streetwear storefront rhythm</small>
            <h2>购物车重复提交<br>一次看懂</h2>
            <p>同一组商品，分别走三条请求链路。你可以直接添加商品后按浏览器刷新，对比 POST 重放、PRG 重定向、以及 Session 请求指纹防重这三种处理结果。</p>
            <div class="hero-badges">
                <span>Session ID <%= sessionId %></span>
                <span>3 Modes</span>
                <span>JSP + Servlet</span>
            </div>
        </div>
        <div class="hero-stats">
            <div class="stat-card">
                <strong>Case 01</strong>
                <b><%= directCount %></b>
                <span>直接 POST 后刷新，浏览器会提示是否重新提交表单，确认后会再次加入商品。</span>
            </div>
            <div class="stat-card">
                <strong>Case 02</strong>
                <b><%= redirectCount %></b>
                <span>加入商品后立即 302 到 GET 页面，刷新只会重放页面请求，不会重放表单提交。</span>
            </div>
            <div class="stat-card">
                <strong>Case 03</strong>
                <b><%= guardCount %></b>
                <span>仍然保留 POST 渲染页面，但通过 Session 记录 requestId，重复刷新不会再次写入购物车。</span>
            </div>
        </div>
    </section>

    <section class="section-head">
        <div>
            <span class="section-kicker">Session-based shopping cart</span>
            <h3>Three Labs / One Storefront</h3>
            <p>视觉上采用黑白米色底、强标题、促销横幅和产品卡片的街头服饰电商语言，功能上则专注于 Servlet 课程里的刷新重复提交问题。</p>
        </div>
        <div class="jump-row">
            <a class="jump-link" href="#direct">
                <strong>Direct</strong>
                <span>刷新会重复提交</span>
            </a>
            <a class="jump-link" href="#redirect">
                <strong>PRG</strong>
                <span>重定向规避重复提交</span>
            </a>
            <a class="jump-link" href="#guard">
                <strong>Session Guard</strong>
                <span>会话去重拦截重复提交</span>
            </a>
        </div>
    </section>

    <div class="labs">
        <section id="direct" class="lab <%= activeClass(activeTab, "direct") %>">
            <div class="lab-head">
                <div>
                    <div class="eyebrow">Case 01</div>
                    <h3 class="lab-title">刷新页面会重复提交商品</h3>
                    <div class="lab-meta">这个实验区在 POST 加入购物车后直接 forward 回页面。浏览器当前历史记录里仍然是 POST，刷新时会再次提交表单，所以同一件商品会继续累加。</div>
                </div>
                <div class="status-chip">Forward After POST</div>
            </div>
            <% if (directNotice != null) { %>
            <div class="notice"><%= directNotice %></div>
            <% } %>
            <div class="lab-grid">
                <div class="products">
                    <% for (Product product : products) { %>
                    <article class="product-card">
                        <div class="product-visual <%= product.getTone() %>">
                            <span class="product-series"><%= product.getSeries() %></span>
                            <span class="product-badge"><%= product.getBadge() %></span>
                        </div>
                        <div class="product-body">
                            <h4 class="product-name"><%= product.getName() %></h4>
                            <div class="product-subtitle"><%= product.getSubtitle() %></div>
                            <div class="product-row">
                                <div class="price"><%= money(product.getPrice()) %></div>
                                <form class="add-form" action="<%= base %>/cart/direct" method="post">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <button class="add-btn direct" type="submit">Add Direct</button>
                                </form>
                            </div>
                        </div>
                    </article>
                    <% } %>
                </div>
                <aside class="cart-panel">
                    <h4>Direct Cart</h4>
                    <p>先点一次商品，再按浏览器刷新，观察数量继续增加。</p>
                    <div class="cart-summary">
                        <div class="summary-box">
                            <strong>Items</strong>
                            <span><%= directCount %></span>
                        </div>
                        <div class="summary-box">
                            <strong>Total</strong>
                            <span><%= money(directTotal) %></span>
                        </div>
                    </div>
                    <% if (directItems == null || directItems.isEmpty()) { %>
                    <div class="cart-empty">购物车还是空的。先加入一件商品，然后刷新当前页面来复现实验现象。</div>
                    <% } else { %>
                    <div class="cart-list">
                        <% for (CartItem item : directItems) { %>
                        <div class="cart-line">
                            <div>
                                <strong><%= item.getProductName() %></strong>
                                <span><%= money(item.getUnitPrice()) %> × <%= item.getQuantity() %></span>
                            </div>
                            <strong><%= money(item.getSubtotal()) %></strong>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                    <div class="panel-actions">
                        <form action="<%= base %>/cart/clear" method="post">
                            <input type="hidden" name="mode" value="direct">
                            <button class="ghost-btn" type="submit">Clear Cart</button>
                        </form>
                        <a class="ghost-btn dark" href="#redirect">Go Next</a>
                    </div>
                </aside>
            </div>
        </section>

        <section id="redirect" class="lab <%= activeClass(activeTab, "redirect") %>">
            <div class="lab-head">
                <div>
                    <div class="eyebrow">Case 02</div>
                    <h3 class="lab-title">使用重定向解决刷新重复提交</h3>
                    <div class="lab-meta">这个实验区使用 POST-Redirect-GET。商品加入 Session 购物车后立刻发送 redirect 到 GET 页面，浏览器刷新时只会重复 GET，不会再次执行添加逻辑。</div>
                </div>
                <div class="status-chip">PRG Pattern</div>
            </div>
            <% if (redirectNotice != null) { %>
            <div class="notice"><%= redirectNotice %></div>
            <% } %>
            <div class="lab-grid">
                <div class="products">
                    <% for (Product product : products) { %>
                    <article class="product-card">
                        <div class="product-visual <%= product.getTone() %>">
                            <span class="product-series"><%= product.getSeries() %></span>
                            <span class="product-badge"><%= product.getBadge() %></span>
                        </div>
                        <div class="product-body">
                            <h4 class="product-name"><%= product.getName() %></h4>
                            <div class="product-subtitle"><%= product.getSubtitle() %></div>
                            <div class="product-row">
                                <div class="price"><%= money(product.getPrice()) %></div>
                                <form class="add-form" action="<%= base %>/cart/redirect" method="post">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <button class="add-btn redirect" type="submit">Add With PRG</button>
                                </form>
                            </div>
                        </div>
                    </article>
                    <% } %>
                </div>
                <aside class="cart-panel">
                    <h4>Redirect Cart</h4>
                    <p>加入商品后地址栏会回到 GET 页面。刷新当前页面不会再次提交表单。</p>
                    <div class="cart-summary">
                        <div class="summary-box">
                            <strong>Items</strong>
                            <span><%= redirectCount %></span>
                        </div>
                        <div class="summary-box">
                            <strong>Total</strong>
                            <span><%= money(redirectTotal) %></span>
                        </div>
                    </div>
                    <% if (redirectItems == null || redirectItems.isEmpty()) { %>
                    <div class="cart-empty">这里用于观察 PRG 行为。加一件商品后连续刷新，你会看到数量保持不变。</div>
                    <% } else { %>
                    <div class="cart-list">
                        <% for (CartItem item : redirectItems) { %>
                        <div class="cart-line">
                            <div>
                                <strong><%= item.getProductName() %></strong>
                                <span><%= money(item.getUnitPrice()) %> × <%= item.getQuantity() %></span>
                            </div>
                            <strong><%= money(item.getSubtotal()) %></strong>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                    <div class="panel-actions">
                        <form action="<%= base %>/cart/clear" method="post">
                            <input type="hidden" name="mode" value="redirect">
                            <button class="ghost-btn" type="submit">Clear Cart</button>
                        </form>
                        <a class="ghost-btn dark" href="#guard">Go Next</a>
                    </div>
                </aside>
            </div>
        </section>

        <section id="guard" class="lab <%= activeClass(activeTab, "guard") %>">
            <div class="lab-head">
                <div>
                    <div class="eyebrow">Case 03</div>
                    <h3 class="lab-title">使用 Session 防止刷新重复提交</h3>
                    <div class="lab-meta">这个实验区依然在 POST 后渲染页面，不依赖重定向，而是把 requestId 记到 Session。浏览器刷新时若重发同一条 POST，请求会被识别为已处理，从而不再重复加入购物车。</div>
                </div>
                <div class="status-chip">Session Request Fingerprint</div>
            </div>
            <% if (guardNotice != null) { %>
            <div class="notice"><%= guardNotice %></div>
            <% } %>
            <div class="lab-grid">
                <div class="products">
                    <% for (Product product : products) { %>
                    <article class="product-card">
                        <div class="product-visual <%= product.getTone() %>">
                            <span class="product-series"><%= product.getSeries() %></span>
                            <span class="product-badge"><%= product.getBadge() %></span>
                        </div>
                        <div class="product-body">
                            <h4 class="product-name"><%= product.getName() %></h4>
                            <div class="product-subtitle"><%= product.getSubtitle() %></div>
                            <div class="product-row">
                                <div class="price"><%= money(product.getPrice()) %></div>
                                <form class="add-form" action="<%= base %>/cart/session-guard" method="post">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    <input type="hidden" name="requestId" value="<%= guardTokens.get(product.getId()) %>">
                                    <button class="add-btn guard" type="submit">Add With Session</button>
                                </form>
                            </div>
                        </div>
                    </article>
                    <% } %>
                </div>
                <aside class="cart-panel">
                    <h4>Session Guard Cart</h4>
                    <p>先加入商品，再直接刷新页面。如果浏览器重发相同 POST，服务器会根据 Session 中的 requestId 去重。</p>
                    <div class="cart-summary">
                        <div class="summary-box">
                            <strong>Items</strong>
                            <span><%= guardCount %></span>
                        </div>
                        <div class="summary-box">
                            <strong>Total</strong>
                            <span><%= money(guardTotal) %></span>
                        </div>
                    </div>
                    <% if (guardItems == null || guardItems.isEmpty()) { %>
                    <div class="cart-empty">这个实验区不会因为刷新而重复加入已处理过的请求。添加任意商品后即可验证。</div>
                    <% } else { %>
                    <div class="cart-list">
                        <% for (CartItem item : guardItems) { %>
                        <div class="cart-line">
                            <div>
                                <strong><%= item.getProductName() %></strong>
                                <span><%= money(item.getUnitPrice()) %> × <%= item.getQuantity() %></span>
                            </div>
                            <strong><%= money(item.getSubtotal()) %></strong>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                    <div class="panel-actions">
                        <form action="<%= base %>/cart/clear" method="post">
                            <input type="hidden" name="mode" value="guard">
                            <button class="ghost-btn" type="submit">Clear Cart</button>
                        </form>
                        <a class="ghost-btn dark" href="#direct">Try Again</a>
                    </div>
                </aside>
            </div>
        </section>
    </div>

    <div class="footnote">
        <strong>Note</strong><br>
        页面视觉借鉴了街头服饰电商常见的强标题、黑白米色基调和促销横幅节奏，用于课程展示；未复制原站品牌标识、商品素材或文案。<br>
        课程演示建议：先在 Direct 区加入 1 次并刷新，观察数量增加；再在 Redirect 区重复同样动作，数量保持不变；最后在 Session Guard 区加入后刷新，观察服务器拦截重复 requestId。
    </div>
</div>
</body>
</html>