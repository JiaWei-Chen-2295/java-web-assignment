<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JavaWeb 作业展示</title>
  <style>
    :root {
      --sidebar-w: 260px;
      --brand: #007AFF;
      --brand-light: #EBF2FF;
      --brand-hover: #0062CC;
      --bg: #F5F5F7;
      --surface: #FFFFFF;
      --text: #1D1D1F;
      --text2: #86868B;
      --text3: #AEAEB2;
      --border: rgba(0,0,0,.08);
      --radius: 10px;
      --radius-lg: 14px;
      --sidebar-bg: rgba(255,255,255,.72);
      --urlbar-bg: rgba(0,0,0,.04);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    html, body {
      height: 100%;
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "PingFang SC",
                   "Helvetica Neue", "Microsoft YaHei", sans-serif;
      color: var(--text);
      background: var(--bg);
      -webkit-font-smoothing: antialiased;
    }

    .app { display: flex; height: 100%; }

    /* ================= 侧边栏 ================= */
    .sidebar {
      width: var(--sidebar-w);
      min-width: var(--sidebar-w);
      background: var(--sidebar-bg);
      backdrop-filter: saturate(180%) blur(20px);
      -webkit-backdrop-filter: saturate(180%) blur(20px);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      z-index: 10;
    }

    /* 品牌头部 */
    .sidebar-brand {
      padding: 20px 18px 14px;
      border-bottom: 1px solid var(--border);
    }

    .brand-row {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .brand-icon {
      width: 34px; height: 34px;
      border-radius: 9px;
      background: linear-gradient(135deg, #5E5CE6, #BF5AF2);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 17px;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(94,92,230,.35);
      flex-shrink: 0;
    }

    .brand-text h1 {
      font-size: 15px;
      font-weight: 600;
      letter-spacing: -0.2px;
    }

    .brand-text span {
      font-size: 11px;
      color: var(--text3);
    }

    /* 搜索 */
    .sidebar-search {
      padding: 10px 14px 6px;
    }

    .search-input {
      width: 100%;
      height: 32px;
      border: none;
      border-radius: 8px;
      background: var(--urlbar-bg);
      padding: 0 10px 0 30px;
      font-size: 12.5px;
      font-family: inherit;
      color: var(--text);
      outline: none;
      transition: background .2s;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' fill='none' viewBox='0 0 24 24' stroke='%2386868B' stroke-width='2.5'%3E%3Ccircle cx='11' cy='11' r='7'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: 9px center;
    }

    .search-input:focus {
      background-color: rgba(0,0,0,.06);
    }

    .search-input::placeholder {
      color: var(--text3);
    }

    /* 导航列表 */
    .nav-scroll {
      flex: 1;
      overflow-y: auto;
      overflow-x: hidden;
      padding: 8px 10px 16px;
    }

    .nav-scroll::-webkit-scrollbar { width: 4px; }
    .nav-scroll::-webkit-scrollbar-thumb {
      background: rgba(0,0,0,.1);
      border-radius: 4px;
    }

    .nav-list { list-style: none; }

    .nav-group {
      margin-bottom: 6px;
    }

    .nav-group-label {
      padding: 14px 8px 5px;
      font-size: 11px;
      font-weight: 600;
      color: var(--text3);
      letter-spacing: 0.3px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .nav-group-label::before {
      content: '';
      display: inline-block;
      width: 4px; height: 4px;
      border-radius: 50%;
      background: var(--text3);
      opacity: .6;
    }

    .nav-item { margin-bottom: 1px; }

    .nav-item a {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 7px 10px;
      border-radius: 8px;
      text-decoration: none;
      color: var(--text);
      font-size: 13px;
      transition: background .15s, color .15s, transform .1s;
      cursor: pointer;
      user-select: none;
      position: relative;
    }

    .nav-item a:hover {
      background: rgba(0,0,0,.04);
    }

    .nav-item a:active {
      transform: scale(.98);
    }

    .nav-item a.active {
      background: var(--brand);
      color: #fff;
      font-weight: 500;
    }

    .nav-item a.active .tag {
      background: rgba(255,255,255,.22);
      color: #fff;
    }

    .nav-item a.active .desc {
      color: rgba(255,255,255,.7);
    }

    .tag {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 42px;
      font-size: 11px;
      font-weight: 600;
      font-family: "SF Mono", "SFMono-Regular", "Fira Code", monospace;
      padding: 2px 7px;
      border-radius: 5px;
      background: var(--urlbar-bg);
      color: var(--text2);
      flex-shrink: 0;
    }

    .nav-info {
      overflow: hidden;
      min-width: 0;
    }

    .nav-title {
      display: block;
      font-weight: 500;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .desc {
      display: block;
      font-size: 11px;
      color: var(--text3);
      margin-top: 1px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* ================= 主内容区 ================= */
    .main {
      flex: 1;
      display: flex;
      flex-direction: column;
      min-width: 0;
      background: var(--bg);
      padding: 12px 12px 12px 0;
    }

    /* macOS 风格浏览器窗口 */
    .browser-window {
      flex: 1;
      display: flex;
      flex-direction: column;
      background: var(--surface);
      border-radius: var(--radius-lg);
      overflow: hidden;
      box-shadow:
        0 0 0 .5px var(--border),
        0 2px 8px rgba(0,0,0,.04),
        0 12px 40px rgba(0,0,0,.06);
    }

    /* 标题栏 */
    .titlebar {
      display: flex;
      align-items: center;
      height: 48px;
      padding: 0 14px;
      background: linear-gradient(180deg, #FAFAFA, #F2F2F2);
      border-bottom: 1px solid var(--border);
      gap: 12px;
      flex-shrink: 0;
    }

    /* 红绿灯 */
    .traffic-lights {
      display: flex;
      gap: 7px;
      flex-shrink: 0;
    }

    .traffic-light {
      width: 12px; height: 12px;
      border-radius: 50%;
      position: relative;
    }

    .tl-close  { background: #FF5F57; box-shadow: inset 0 0 0 .5px rgba(0,0,0,.08); }
    .tl-min    { background: #FEBC2E; box-shadow: inset 0 0 0 .5px rgba(0,0,0,.08); }
    .tl-max    { background: #28C840; box-shadow: inset 0 0 0 .5px rgba(0,0,0,.08); }

    .traffic-lights:hover .tl-close::after,
    .traffic-lights:hover .tl-min::after,
    .traffic-lights:hover .tl-max::after {
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 10px;
      font-weight: 700;
      color: rgba(0,0,0,.45);
    }

    .traffic-lights:hover .tl-close::after { content: '\00D7'; font-size: 12px; }
    .traffic-lights:hover .tl-min::after   { content: '\2013'; font-size: 13px; }
    .traffic-lights:hover .tl-max::after   { content: '\002B'; font-size: 13px; }

    /* 导航箭头 */
    .nav-arrows {
      display: flex;
      gap: 2px;
      flex-shrink: 0;
    }

    .nav-arrows button {
      width: 28px; height: 28px;
      border: none;
      background: transparent;
      border-radius: 6px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--text3);
      transition: background .15s, color .15s;
    }

    .nav-arrows button:hover {
      background: rgba(0,0,0,.06);
      color: var(--text);
    }

    .nav-arrows button:disabled {
      opacity: .35;
      cursor: default;
    }

    .nav-arrows button:disabled:hover {
      background: transparent;
      color: var(--text3);
    }

    .nav-arrows svg {
      width: 16px; height: 16px;
    }

    /* URL 地址栏 */
    .urlbar-wrap {
      flex: 1;
      position: relative;
      min-width: 0;
    }

    .urlbar {
      width: 100%;
      height: 30px;
      border: 1px solid rgba(0,0,0,.1);
      border-radius: 7px;
      background: var(--surface);
      padding: 0 32px 0 12px;
      font-size: 12.5px;
      font-family: "SF Mono", "SFMono-Regular", "Fira Code", monospace;
      color: var(--text);
      outline: none;
      transition: border-color .2s, box-shadow .2s;
      cursor: default;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .urlbar:not(:focus) {
      color: var(--text2);
      text-align: center;
    }

    .urlbar:focus {
      border-color: var(--brand);
      box-shadow: 0 0 0 3px rgba(0,122,255,.15);
      cursor: text;
      color: var(--text);
      text-align: left;
    }

    /* 锁图标 */
    .lock-icon {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: var(--text3);
    }

    .lock-icon svg {
      width: 12px; height: 12px;
    }

    /* 模块标题 */
    .module-title {
      font-size: 13px;
      font-weight: 500;
      color: var(--text);
      white-space: nowrap;
      flex-shrink: 0;
      max-width: 160px;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* iframe 区 */
    .frame-wrap {
      flex: 1;
      position: relative;
      background: #fff;
    }

    .frame-wrap iframe {
      width: 100%;
      height: 100%;
      border: none;
    }

    /* 欢迎页 */
    .welcome {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
      gap: 14px;
      background: var(--surface);
    }

    .welcome .dots {
      display: flex; gap: 8px; margin-bottom: 6px;
    }

    .welcome .dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      animation: pulse 1.8s ease-in-out infinite;
    }

    .welcome .dot:nth-child(1) { background: #FF5F57; animation-delay: 0s; }
    .welcome .dot:nth-child(2) { background: #FEBC2E; animation-delay: .3s; }
    .welcome .dot:nth-child(3) { background: #28C840; animation-delay: .6s; }

    @keyframes pulse {
      0%, 100% { opacity: .4; transform: scale(.9); }
      50% { opacity: 1; transform: scale(1.1); }
    }

    .welcome h2 {
      font-size: 20px;
      font-weight: 600;
      color: var(--text);
      letter-spacing: -0.3px;
    }

    .welcome p {
      font-size: 13.5px;
      color: var(--text2);
    }
  </style>
</head>
<body>
<div class="app">
  <!-- 侧边栏 -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="brand-row">
        <div class="brand-icon">J</div>
        <div class="brand-text">
          <h1>JavaWeb 作业</h1>
          <span>Showcase</span>
        </div>
      </div>
    </div>
    <div class="sidebar-search">
      <input type="text" class="search-input" id="search-input" placeholder="搜索模块...">
    </div>
    <div class="nav-scroll">
      <ul class="nav-list" id="nav-list"></ul>
    </div>
  </aside>

  <!-- 主内容 -->
  <section class="main">
    <div class="browser-window">
      <!-- 模拟标题栏 -->
      <div class="titlebar">
        <div class="traffic-lights">
          <div class="traffic-light tl-close"></div>
          <div class="traffic-light tl-min"></div>
          <div class="traffic-light tl-max"></div>
        </div>
        <div class="nav-arrows">
          <button id="btn-back" disabled title="后退">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
          </button>
          <button id="btn-forward" disabled title="前进">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
          </button>
        </div>
        <div class="urlbar-wrap">
          <input type="text" class="urlbar" id="urlbar" value="" readonly>
          <span class="lock-icon">
            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 1C8.676 1 6 3.676 6 7v2H4v14h16V9h-2V7c0-3.324-2.676-6-6-6zm0 2c2.276 0 4 1.724 4 4v2H8V7c0-2.276 1.724-4 4-4z"/></svg>
          </span>
        </div>
        <span class="module-title" id="module-title"></span>
      </div>

      <!-- iframe 区 -->
      <div class="frame-wrap" id="frame-wrap">
        <div class="welcome" id="welcome-screen">
          <div class="dots">
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
          </div>
          <h2>选择左侧模块开始浏览</h2>
          <p>点击导航中的作业链接，内容将在此处展示</p>
        </div>
      </div>
    </div>
  </section>
</div>

<script>
  const navList    = document.getElementById('nav-list');
  const frameWrap  = document.getElementById('frame-wrap');
  const urlbar     = document.getElementById('urlbar');
  const titleEl    = document.getElementById('module-title');
  const btnBack    = document.getElementById('btn-back');
  const btnFwd     = document.getElementById('btn-forward');
  const searchInput = document.getElementById('search-input');

  // 浏览历史
  let history = [];
  let historyIdx = -1;
  let allItems = [];  // 搜索用

  function loadModule(url, title, desc, pushHist) {
    if (pushHist === undefined) pushHist = true;

    urlbar.value = url;
    titleEl.textContent = title;

    var iframe = document.createElement('iframe');
    iframe.setAttribute('sandbox', 'allow-scripts allow-same-origin allow-forms allow-popups');
    iframe.src = url;
    lastSyncedUrl = '';

    // 每次 iframe 加载完成后，尝试读取其真实 URL 并同步到地址栏
    iframe.addEventListener('load', function() {
      syncUrlFromIframe(iframe);
    });

    frameWrap.innerHTML = '';
    frameWrap.appendChild(iframe);

    // 启动轮询，实时跟踪 iframe 内部 URL 变化
    startUrlPolling(iframe);

    // 更新导航高亮
    navList.querySelectorAll('.nav-item a').forEach(a => {
      a.classList.toggle('active', a.getAttribute('data-url') === url);
    });

    if (pushHist) {
      history = history.slice(0, historyIdx + 1);
      history.push({ url: url, title: title, desc: desc });
      historyIdx = history.length - 1;
    }
    updateNavButtons();
  }

  // 定时轮询 iframe 内部 URL 变化（用于 SPA 路由等 load 事件不触发的场景）
  let urlPollTimer = null;
  let lastSyncedUrl = '';

  function startUrlPolling(iframe) {
    stopUrlPolling();
    urlPollTimer = setInterval(function() {
      syncUrlFromIframe(iframe);
    }, 500);
  }

  function stopUrlPolling() {
    if (urlPollTimer) {
      clearInterval(urlPollTimer);
      urlPollTimer = null;
    }
  }

  function syncUrlFromIframe(iframe) {
    try {
      var iframeUrl = iframe.contentWindow.location.href;
      // 提取路径部分（去掉 host）
      var path;
      try {
        var u = new URL(iframeUrl);
        path = u.pathname + u.search;
      } catch(e) {
        path = iframeUrl;
      }

      if (path && path !== lastSyncedUrl) {
        lastSyncedUrl = path;
        urlbar.value = path;

        // 同步更新历史栈顶
        if (historyIdx >= 0) {
          history[historyIdx].url = path;
        }

        // 同步更新左侧高亮（尝试匹配最接近的模块）
        navList.querySelectorAll('.nav-item a').forEach(function(a) {
          var moduleUrl = a.getAttribute('data-url');
          a.classList.toggle('active', path.startsWith(moduleUrl));
        });
      }
    } catch(e) {
      // 跨域安全限制，无法读取 — 保持当前 URL 不变
    }
  }

  function updateNavButtons() {
    btnBack.disabled = historyIdx <= 0;
    btnFwd.disabled  = historyIdx >= history.length - 1;
  }

  btnBack.addEventListener('click', function() {
    if (historyIdx > 0) {
      historyIdx--;
      var h = history[historyIdx];
      loadModule(h.url, h.title, h.desc, false);
    }
  });

  btnFwd.addEventListener('click', function() {
    if (historyIdx < history.length - 1) {
      historyIdx++;
      var h = history[historyIdx];
      loadModule(h.url, h.title, h.desc, false);
    }
  });

  // URL 栏：点击可编辑，回车导航
  urlbar.addEventListener('click', function() {
    this.removeAttribute('readonly');
    this.select();
  });

  urlbar.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      this.setAttribute('readonly', '');
      this.blur();
      var newUrl = this.value.trim();
      if (newUrl && !newUrl.startsWith('/')) newUrl = '/' + newUrl;
      if (newUrl) {
        loadModule(newUrl, titleEl.textContent, '', true);
      }
    } else if (e.key === 'Escape') {
      this.setAttribute('readonly', '');
      this.blur();
      // 恢复当前历史的 URL
      if (historyIdx >= 0) {
        this.value = history[historyIdx].url;
      }
    }
  });

  urlbar.addEventListener('blur', function() {
    this.setAttribute('readonly', '');
  });

  // 搜索过滤
  searchInput.addEventListener('input', function() {
    var q = this.value.toLowerCase().trim();
    navList.querySelectorAll('.nav-item').forEach(function(li) {
      var text = li.textContent.toLowerCase();
      li.style.display = (!q || text.indexOf(q) !== -1) ? '' : 'none';
    });
    // 隐藏空分组
    navList.querySelectorAll('.nav-group').forEach(function(g) {
      var visible = g.querySelectorAll('.nav-item:not([style*="display: none"])');
      g.style.display = visible.length ? '' : 'none';
    });
  });

  // 渲染导航
  fetch('<%= request.getContextPath() %>/api/modules')
    .then(function(r) { return r.json(); })
    .then(function(groups) {
      groups.forEach(function(group) {
        var groupEl = document.createElement('li');
        groupEl.className = 'nav-group';

        var label = document.createElement('div');
        label.className = 'nav-group-label';
        label.textContent = group.label;
        groupEl.appendChild(label);

        group.items.forEach(function(item) {
          allItems.push(item);

          var li = document.createElement('li');
          li.className = 'nav-item';

          var a = document.createElement('a');
          a.href = 'javascript:void(0)';
          a.setAttribute('data-url', item.url);
          a.innerHTML =
            '<span class="tag">' + item.id + '</span>' +
            '<span class="nav-info">' +
              '<span class="nav-title">' + item.title + '</span>' +
              '<span class="desc">' + item.desc + '</span>' +
            '</span>';

          a.addEventListener('click', function() {
            loadModule(item.url, item.title, item.desc, true);
          });

          li.appendChild(a);
          groupEl.appendChild(li);
        });

        navList.appendChild(groupEl);
      });

      // 默认选中第一个
      var first = navList.querySelector('.nav-item a');
      if (first) first.click();
    });
</script>
</body>
</html>
