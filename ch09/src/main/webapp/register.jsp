<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户注册</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, 'Microsoft YaHei', Arial, sans-serif;
      min-height: 100vh;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex; align-items: center; justify-content: center;
    }
    .card {
      background: rgba(255,255,255,0.95);
      backdrop-filter: blur(10px);
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
      padding: 45px 40px;
      width: 420px;
      animation: fadeUp 0.6s ease-out;
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .card h2 {
      text-align: center;
      color: #333;
      font-weight: 600;
      font-size: 1.8em;
      margin-bottom: 8px;
    }
    .card .subtitle {
      text-align: center;
      color: #999;
      margin-bottom: 30px;
      font-size: 0.95em;
    }
    .form-group {
      margin-bottom: 20px;
      position: relative;
    }
    .form-group label {
      display: block;
      margin-bottom: 6px;
      color: #555;
      font-size: 0.9em;
      font-weight: 500;
    }
    .form-group input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e8e8e8;
      border-radius: 12px;
      font-size: 1em;
      transition: all 0.3s;
      outline: none;
      background: #fafafa;
    }
    .form-group input:focus {
      border-color: #667eea;
      background: #fff;
      box-shadow: 0 0 0 4px rgba(102,126,234,0.1);
    }
    .form-group .tip {
      font-size: 0.8em;
      margin-top: 5px;
      height: 18px;
    }
    .tip.ok   { color: #43a047; }
    .tip.err  { color: #e53935; }
    .form-group input.valid   { border-color: #43a047; }
    .form-group input.invalid { border-color: #e53935; }

    .btn {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 1.05em;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      margin-top: 10px;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(102,126,234,0.4);
    }
    .btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }
    .error-msg {
      background: #fff3f3;
      color: #e53935;
      padding: 10px 16px;
      border-radius: 10px;
      font-size: 0.9em;
      margin-bottom: 20px;
      border-left: 4px solid #e53935;
    }
    .footer-link {
      text-align: center;
      margin-top: 25px;
      color: #999;
      font-size: 0.9em;
    }
    .footer-link a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
    }
    .footer-link a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="card">
    <h2>创建账号</h2>
    <p class="subtitle">欢迎加入，请填写以下信息完成注册</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="error-msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <form id="regForm" action="register" method="post" novalidate>
      <div class="form-group">
        <label>用户名</label>
        <input type="text" id="username" name="username" placeholder="请输入用户名" required>
        <div class="tip" id="usernameTip"></div>
      </div>
      <div class="form-group">
        <label>密码</label>
        <input type="password" id="password" name="password" placeholder="请输入密码" required>
        <div class="tip" id="passwordTip"></div>
      </div>
      <div class="form-group">
        <label>确认密码</label>
        <input type="password" id="confirmPwd" placeholder="请再次输入密码">
        <div class="tip" id="confirmTip"></div>
      </div>
      <div class="form-group">
        <label>邮箱</label>
        <input type="email" id="email" name="email" placeholder="选填">
      </div>
      <div class="form-group">
        <label>手机号</label>
        <input type="text" id="phone" name="phone" placeholder="选填">
      </div>
      <button type="submit" class="btn" id="submitBtn">注 册</button>
    </form>

    <div class="footer-link">
      已有账号？<a href="login.jsp">去登录</a>
    </div>
  </div>

<script>
  const usernameInput = document.getElementById('username');
  const usernameTip   = document.getElementById('usernameTip');
  const pwdInput      = document.getElementById('password');
  const pwdTip        = document.getElementById('passwordTip');
  const confirmInput  = document.getElementById('confirmPwd');
  const confirmTip    = document.getElementById('confirmTip');
  const form          = document.getElementById('regForm');
  let usernameAvailable = false;
  let timer = null;

  // AJAX 查重：用户停止输入 400ms 后发送请求
  usernameInput.addEventListener('input', function() {
    clearTimeout(timer);
    const val = this.value.trim();
    this.classList.remove('valid','invalid');
    usernameTip.className = 'tip';

    if (!val) {
      usernameTip.textContent = '';
      usernameAvailable = false;
      return;
    }
    usernameTip.textContent = '正在检查...';
    usernameTip.className = 'tip';

    timer = setTimeout(function() {
      fetch('checkUsername?username=' + encodeURIComponent(val))
        .then(r => r.json())
        .then(data => {
          if (data.exists) {
            usernameTip.textContent = '该用户名已被注册';
            usernameTip.className = 'tip err';
            usernameInput.classList.add('invalid');
            usernameInput.classList.remove('valid');
            usernameAvailable = false;
          } else {
            usernameTip.textContent = '用户名可用';
            usernameTip.className = 'tip ok';
            usernameInput.classList.add('valid');
            usernameInput.classList.remove('invalid');
            usernameAvailable = true;
          }
        })
        .catch(() => {
          usernameTip.textContent = '网络异常，请重试';
          usernameTip.className = 'tip err';
          usernameAvailable = false;
        });
    }, 400);
  });

  // 密码校验
  pwdInput.addEventListener('input', function() {
    if (this.value.length > 0 && this.value.length < 6) {
      pwdTip.textContent = '密码至少6位';
      pwdTip.className = 'tip err';
    } else {
      pwdTip.textContent = '';
      pwdTip.className = 'tip';
    }
    checkConfirm();
  });

  confirmInput.addEventListener('input', checkConfirm);

  function checkConfirm() {
    if (!confirmInput.value) {
      confirmTip.textContent = '';
      confirmTip.className = 'tip';
      return;
    }
    if (confirmInput.value !== pwdInput.value) {
      confirmTip.textContent = '两次密码不一致';
      confirmTip.className = 'tip err';
    } else {
      confirmTip.textContent = '密码一致';
      confirmTip.className = 'tip ok';
    }
  }

  // 表单提交拦截
  form.addEventListener('submit', function(e) {
    const u = usernameInput.value.trim();
    const p = pwdInput.value;
    const c = confirmInput.value;

    if (!u) { usernameTip.textContent = '请输入用户名'; usernameTip.className='tip err'; e.preventDefault(); return; }
    if (!usernameAvailable) { e.preventDefault(); return; }
    if (!p || p.length < 6) { pwdTip.textContent = '密码至少6位'; pwdTip.className='tip err'; e.preventDefault(); return; }
    if (p !== c) { confirmTip.textContent = '两次密码不一致'; confirmTip.className='tip err'; e.preventDefault(); return; }
  });
</script>
</body>
</html>
