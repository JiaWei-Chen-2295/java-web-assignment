# 实验目的
通过本次实验掌握基于 `HttpSession` 的身份验证机制，理解登录态维护、页面访问控制与退出登录的实现流程。  
结合验证码校验，进一步理解会话中临时数据的存取与销毁时机，提升 Web 应用基础安全意识。

# 实验环境
- 操作系统：Windows 11  
- 开发工具：VS Code  
- 构建工具：Maven 3.x  
- JDK：17  
- Web 技术栈：Jakarta Servlet 6.1 + JSP 3.1  
- 服务器：Tomcat 10+（Jakarta 命名空间）

# 实验步骤
1. 创建并配置 `ch13-session-profile` Web 工程，补充 `pom.xml` 与 `web.xml`，设置 session 超时时间为 30 分钟。  
2. 编写登录页 `login-session.jsp`，包含用户名、密码、验证码输入项，并提交到 `/doLogin`。  
3. 实现 `CaptchaServlet`（`/captcha`）：动态生成验证码图片，将验证码字符串写入 `session`。  
4. 实现 `LoginServlet`（`/doLogin`）：依次校验验证码、账号密码，登录成功后将 `loginUser` 和 `loginTime` 写入 `session`。  
5. 在 `profile.jsp` 做访问保护：若 `session` 中无 `loginUser`，立即重定向到登录页；有则展示用户信息和会话信息。  
6. 实现 `LogoutServlet`（`/doLogout`）：调用 `session.invalidate()` 清空登录态并返回登录页。  
7. 进行功能验证：  
   - 未登录访问 `profile.jsp` 会被拦截；  
   - 错误验证码/密码提示失败；  
   - 登录成功进入个人中心；  
   - 退出后再次访问受保护页面需重新登录。

# 核心代码
文件：`src/main/java/fun/javierchen/sessionprofile/LoginServlet.java`

```java
@WebServlet("/doLogin")
public class LoginServlet extends HttpServlet {

    private static final Map<String, String> USERS = new ConcurrentHashMap<>();
    static {
        USERS.put("admin", "123456");
        USERS.put("javierchen", "hello");
        USERS.put("demo", "demo");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String captchaInput = req.getParameter("captcha");

        HttpSession session = req.getSession();
        String captchaExpected = (String) session.getAttribute("captcha");

        // 1) 验证码校验
        if (captchaExpected == null || captchaInput == null
                || !captchaExpected.equalsIgnoreCase(captchaInput.trim())) {
            req.setAttribute("error", "验证码错误");
            req.getRequestDispatcher("login-session.jsp").forward(req, resp);
            return;
        }
        session.removeAttribute("captcha");

        // 2) 账号密码校验
        String stored = USERS.get(username.trim());
        if (stored == null || !stored.equals(password)) {
            req.setAttribute("error", "用户名或密码错误");
            req.getRequestDispatcher("login-session.jsp").forward(req, resp);
            return;
        }

        // 3) 登录成功，写入会话
        session.setAttribute("loginUser", username.trim());
        session.setAttribute("loginTime", LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        resp.sendRedirect("profile.jsp");
    }
}
```

文件：`src/main/webapp/profile.jsp`（访问保护关键逻辑）

```jsp
<%
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login-session.jsp");
        return;
    }
%>
```

文件：`src/main/java/fun/javierchen/sessionprofile/LogoutServlet.java`

```java
@WebServlet("/doLogout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect("login-session.jsp");
    }
}
```

# 图片说明
建议在报告中插入以下截图（可按你的实际文件名替换）：

- 登录页面（含验证码）  
`![登录页](/images/ch13-login-page.png)`

- 输入错误验证码后的提示  
`![验证码错误提示](/images/ch13-captcha-error.png)`

- 登录成功后的个人资料页（显示 loginTime / Session 信息）  
`![个人资料页](/images/ch13-profile.png)`

- 点击退出后返回登录页  
`![退出登录](/images/ch13-logout.png)`

# 实验总结
本次实验完成了基于 Session 的身份验证闭环：`登录 -> 会话持久化 -> 页面鉴权 -> 退出销毁`。  
通过验证码与错误回显机制，提升了登录流程的可用性与安全性。实验表明，使用 `HttpSession` 能快速实现中小型系统登录态管理，但在生产场景中仍需进一步增强（如密码加密存储、CSRF 防护、统一拦截器鉴权、会话固定攻击防护等）。
