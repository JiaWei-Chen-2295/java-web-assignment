# Java Web 实验报告

## 1 实验目的

通过本次实验掌握 Java Web 开发中的核心概念与技术，包括 Servlet 编程、用户注册与登录实现、错误页面配置、JSP 包含指令应用等，理解 Web 应用的整体架构与设计模式。

## 2 实验环境

| 项目 | 说明 |
|------|------|
| 操作系统 | Windows 11 |
| 开发工具 | IntelliJ IDEA / Eclipse |
| Java 版本 | JDK 17+ |
| Web 容器 | Apache Tomcat 10+ |
| 构建工具 | Maven |
| 技术规范 | Jakarta EE (Servlet 6.0, JSP 3.1) |

## 3 实验内容一：用户注册模块 (ch05)

### 3.1 需求分析

设计一个用户注册功能，用户通过 HTML 表单提交学号和姓名作为账号，后台 Servlet 处理注册逻辑，将用户信息保存到服务器文件中。

### 3.2 算法设计

**注册流程算法：**
1. 用户访问 `register.html` 填写注册表单
2. 表单通过 POST 方法提交到 `RegisterServlet`
3. Servlet 接收并验证输入参数（学号+姓名格式）
4. 检查账号是否已存在于 `users.txt` 文件中
5. 若账号不存在，则将账号和密码追加到文件
6. 根据处理结果重定向到成功或失败页面

**数据验证算法：**
- 账号格式：学号+姓名（如：2024001张三）
- 密码：任意非空字符串
- 重复检测：逐行读取文件，比较账号字段

### 3.3 文件结构

```
ch05/
├── src/main/
│   ├── java/fun/javierchen/ch05/
│   │   ├── LoginServlet.java      # 登录处理 Servlet
│   │   └── RegisterServlet.java   # 注册处理 Servlet
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml            # Servlet 配置
│       ├── register.html          # 注册页面
│       ├── login1_contextpath.jsp # 登录页面（多种路径写法示例）
│       ├── login2_relative.jsp
│       ├── login3_server-relative.jsp
│       ├── login4_page-relative.jsp
│       ├── success.html           # 注册成功页面
│       └── failure.html           # 注册失败页面
└── pom.xml
```

### 3.4 核心代码说明

**RegisterServlet.java 关键逻辑：**

```java
// 1. 设置请求编码
request.setCharacterEncoding("UTF-8");

// 2. 获取表单参数
String account = request.getParameter("account");
String password = request.getParameter("password");

// 3. 参数验证
if (account == null || account.trim().isEmpty() ||
    password == null || password.trim().isEmpty()) {
    response.sendRedirect("failure.html");
    return;
}

// 4. 检查账号是否存在
Path filePath = getDataFilePath();
if (isAccountExists(filePath, account)) {
    response.sendRedirect("failure.html");
    return;
}

// 5. 保存用户信息
saveUser(filePath, account, password);
response.sendRedirect("success.html");
```

**数据存储设计：**
- 存储位置：`WEB-INF/data/users.txt`
- 存储格式：`账号,密码`（每行一个用户）
- 安全性：WEB-INF 目录下的文件无法被客户端直接访问

### 3.5 运行截图

**图3.5-1 注册页面**
![注册页面](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/register-page.png '注册页面')

**图3.5-2 注册成功**
![注册成功](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/register-success.png '注册成功')

### 3.6 AI 提示词记录

**使用的 AI 提示词：**
```
请帮我设计一个 Java Web 用户注册功能，要求：
1. 前端使用 HTML 表单，包含账号和密码输入框
2. 账号格式为"学号+姓名"，如 2024001张三
3. 后端使用 Servlet 处理注册请求
4. 用户数据保存到服务器文件（users.txt）
5. 需要检查账号是否已存在
6. 注册成功跳转到 success.html，失败跳转到 failure.html
7. 使用文件存储而非数据库
```

**AI 生成代码分析：**
- 优点：代码结构清晰，包含完整的异常处理和数据验证
- 改进点：可以增加密码加密、更严格的格式验证等

## 4 实验内容二：错误页面配置 (ch08)

### 4.1 需求分析

为 Web 应用配置统一的错误处理页面，处理以下三种错误类型：
1. **404 错误**：请求的文件或资源不存在
2. **算术运算错误**：ArithmeticException（如除零错误）
3. **500 错误**：服务器内部程序错误

### 4.2 web.xml 配置方法

**配置策略：**
在 `web.xml` 中使用 `<error-page>` 元素配置错误页面，支持两种配置方式：
- `<error-code>`：按 HTTP 状态码配置（如 404、500）
- `<exception-type>`：按 Java 异常类型配置（如 java.lang.ArithmeticException）

### 4.3 核心配置代码

**web.xml 配置：**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
                             https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <!-- 404 文件未找到 -->
    <error-page>
        <error-code>404</error-code>
        <location>/error404.jsp</location>
    </error-page>

    <!-- ArithmeticException 算术运算错误 -->
    <error-page>
        <exception-type>java.lang.ArithmeticException</exception-type>
        <location>/errorArithmetic.jsp</location>
    </error-page>

    <!-- 500 服务器内部错误 -->
    <error-page>
        <error-code>500</error-code>
        <location>/error500.jsp</location>
    </error-page>

</web-app>
```

### 4.4 错误页面设计

**404 错误页面 (error404.jsp)：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>404 - 页面未找到</title>
</head>
<body>
    <h2>404 - 您请求的页面不存在</h2>
    <p>请检查 URL 是否正确，或返回 <a href="error.jsp">首页</a>。</p>
</body>
</html>
```

**算术运算错误页面 (errorArithmetic.jsp)：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>算术运算错误</title>
</head>
<body>
    <h2>发生了算术运算错误（ArithmeticException）</h2>
    <p>错误类型：<%= exception.getClass().getName() %></p>
    <p>错误信息：<%= exception.getMessage() %></p>
    <p>此错误由 web.xml 中 &lt;exception-type&gt; 配置捕获。</p>
</body>
</html>
```

**500 错误页面 (error500.jsp)：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>500 - 服务器内部错误</title>
</head>
<body>
    <h2>500 - 服务器内部错误</h2>
    <%
        if (exception != null) {
    %>
    <p>错误类型：<%= exception.getClass().getName() %></p>
    <p>错误信息：<%= exception.getMessage() %></p>
    <%
        } else {
    %>
    <p>服务器发生了未知错误，请稍后再试。</p>
    <%
        }
    %>
    <p>此错误由 web.xml 中 &lt;error-code&gt; 500 配置捕获。</p>
</body>
</html>
```

### 4.5 触发错误的测试页面

**trigger500.jsp（触发 500 错误）：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 故意制造算术运算错误（除零）
    int result = 10 / 0;
%>
```

### 4.6 与课件内容对比

| 对比项 | 课件内容 | 本实验实现 | 差异说明 |
|--------|----------|------------|----------|
| 配置方式 | 使用 `<error-page>` 标签 | 使用 `<error-page>` 标签 | 完全一致 |
| 错误码配置 | 支持 404、500 等 | 支持 404、500 | 一致 |
| 异常类型配置 | 使用 `<exception-type>` | 使用 `<exception-type>` | 一致 |
| isErrorPage 属性 | 需要在 JSP 中设置 | 已在所有错误页面设置 | 一致 |
| exception 隐式对象 | 通过 `isErrorPage="true"` 启用 | 正确使用 exception 对象 | 一致 |
| 路径配置 | 使用 `/` 开头的上下文相对路径 | 使用 `/error404.jsp` 等 | 一致 |

### 4.7 AI 提示词记录

**使用的 AI 提示词：**
```
在 Java Web 项目中，如何在 web.xml 中配置错误页面？
需要处理以下三种错误：
1. 404 文件未找到错误
2. 算术运算错误（ArithmeticException）
3. 500 服务器内部错误

请提供完整的 web.xml 配置示例，以及对应的 JSP 错误页面代码。
要求错误页面能够显示错误类型和错误信息。
```

### 4.8 运行截图

**图4.8-1 404 错误页面**
![404错误](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/error404.png '404错误页面')

**图4.8-2 算术运算错误页面**
![算术错误](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/error-arithmetic.png '算术运算错误')

**图4.8-3 500 错误页面**
![500错误](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/error500.png '500错误页面')

## 5 实验内容三：JSP 包含指令与页面布局 (spring)

### 5.1 需求分析

设计一个校园文化旅游宣传网站，要求：
1. 1 个主页面（index.jsp）
2. 至少 4 个二级导航页面
3. 使用 JSP 包含指令实现统一布局
4. 将页头、导航、页脚等做成包含文件
5. 页面样式美观，具有春季主题特色

### 5.2 页面结构设计

**网站结构：**
```
主页面 (index.jsp)
├── 景点介绍 (scenic.jsp)
├── 文化底蕴 (culture.jsp)
├── 游览路线 (routes.jsp)
├── 关于我们 (about.jsp)
└── 联系方式 (contact.jsp)
```

**统一布局组件：**
```
includes/
├── header.jspf    # 页头（网站标题和标语）
├── nav.jspf       # 导航栏（主导航链接）
├── footer.jspf    # 页脚（版权信息和快速链接）
├── style.jspf     # 样式表（全局 CSS 样式）
└── slider.jspf    # 轮播图（首页特色组件）
```

### 5.3 文件结构

```
spring/
├── src/main/webapp/
│   ├── includes/
│   │   ├── header.jspf    # 页头组件
│   │   ├── nav.jspf       # 导航组件
│   │   ├── footer.jspf    # 页脚组件
│   │   ├── style.jspf     # 样式组件
│   │   └── slider.jspf    # 轮播图组件
│   ├── index.jsp          # 主页
│   ├── scenic.jsp         # 景点介绍页
│   ├── culture.jsp        # 文化底蕴页
│   ├── routes.jsp         # 游览路线页
│   ├── about.jsp          # 关于我们页
│   └── contact.jsp        # 联系方式页
├── code.txt
└── pom.xml
```

### 5.4 JSP 包含指令应用

**静态包含 vs 动态包含：**

| 特性 | 静态包含 `<%@ include %>` | 动态包含 `<jsp:include>` |
|------|---------------------------|--------------------------|
| 执行时机 | 翻译阶段（编译时） | 请求阶段（运行时） |
| 性能 | 更快（只编译一次） | 稍慢（每次请求执行） |
| 参数传递 | 不支持 | 支持 `<jsp:param>` |
| 适用场景 | 静态内容（页头、页脚、样式） | 动态内容（根据条件变化） |

**本实验采用静态包含**，因为页头、导航、页脚等内容在所有页面中是固定的。

### 5.5 核心代码说明

**主页面 (index.jsp) 结构：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>  <!-- 包含样式 -->
</head>
<body>
  <%@ include file="includes/header.jspf" %>  <!-- 包含页头 -->
  <%@ include file="includes/nav.jspf" %>     <!-- 包含导航 -->

  <div class="container">
    <%@ include file="includes/slider.jspf" %>  <!-- 包含轮播图 -->
    
    <!-- 主页内容 -->
    <h2 class="section-title">Campus Highlights</h2>
    <div class="feature-list">...</div>
    
    <div class="three-col">
      <!-- 三栏布局：侧边栏、主内容、侧边栏 -->
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>  <!-- 包含页脚 -->
</body>
</html>
```

**导航组件 (nav.jspf)：**
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="nav">
  <ul>
    <li><a href="index.jsp" class="${param.page == 'index' || empty param.page ? 'active' : ''}">首页</a></li>
    <li><a href="scenic.jsp" class="${param.page == 'scenic' ? 'active' : ''}">景点介绍</a></li>
    <li><a href="culture.jsp" class="${param.page == 'culture' ? 'active' : ''}">文化底蕴</a></li>
    <li><a href="routes.jsp" class="${param.page == 'routes' ? 'active' : ''}">游览路线</a></li>
    <li><a href="about.jsp" class="${param.page == 'about' ? 'active' : ''}">关于我们</a></li>
    <li><a href="contact.jsp" class="${param.page == 'contact' ? 'active' : ''}">联系方式</a></li>
  </ul>
</nav>
```

**样式组件 (style.jspf) 关键样式：**
- 渐变色背景：`linear-gradient(135deg, #e8f5e9 0%, #fff8e1 100%)`
- 春季绿色主题：`#2e7d32`（主色）、`#66bb6a`（辅色）
- 响应式设计：适配移动端和桌面端
- 卡片式布局：阴影、圆角、悬停效果

### 5.6 时间显示功能实现

**使用静态包含完成时间显示：**

可以在页头或页脚中添加实时时间显示，使用 JavaScript 实现：

```jsp
<!-- 在 header.jspf 或 footer.jspf 中添加 -->
<div id="current-time"></div>
<script>
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('current-time').textContent = timeString;
}
updateTime();
setInterval(updateTime, 1000);
</script>
```

### 5.7 AI 提示词记录

**使用的 AI 提示词：**
```
请帮我设计一个校园文化旅游宣传网站，要求：
1. 使用 JSP 技术
2. 1 个主页面 + 4 个二级导航页面
3. 使用 JSP 静态包含指令实现统一布局
4. 将页头、导航、页脚做成独立的包含文件
5. 页面主题：春季校园旅游
6. 样式要求：美观、现代化、响应式设计
7. 使用绿色系作为主色调（象征春天）

请提供完整的文件结构和核心代码示例。
```

### 5.8 运行截图

**图5.8-1 主页面**
![主页](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/spring-index.png '校园旅游主页')

**图5.8-2 景点介绍页**
![景点](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/spring-scenic.png '景点介绍页')

**图5.8-3 文化底蕴页**
![文化](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/spring-culture.png '文化底蕴页')

**图5.8-4 游览路线页**
![路线](https://5fjdvh6z4gqjtou3.public.blob.vercel-storage.com/images/spring-routes.png '游览路线页')

## 6 实验过程中遇到的问题与解决

### 6.1 中文编码问题

**问题描述：** 注册表单提交中文姓名时，Servlet 接收到乱码。

**原因分析：** Tomcat 默认使用 ISO-8859-1 编码处理 POST 请求体。

**解决方法：**
```java
request.setCharacterEncoding("UTF-8");
```
在处理请求参数之前设置请求编码为 UTF-8。

### 6.2 文件路径问题

**问题描述：** 使用相对路径保存用户数据文件时，文件位置不确定。

**原因分析：** 相对路径相对于 JVM 工作目录，而非 Web 应用目录。

**解决方法：**
```java
String dataDir = getServletContext().getRealPath("/WEB-INF/data");
```
使用 `getRealPath()` 获取 Web 应用的绝对路径。

### 6.3 JSP 包含文件扩展名选择

**问题描述：** 包含文件应该使用 `.jsp` 还是 `.jspf` 扩展名？

**解决方法：**
- `.jspf` (JSP Fragment) 是 JSP 片段的标准扩展名
- 明确表示这些文件不能直接访问，只能被包含
- 可以在 `web.xml` 中配置阻止直接访问 `.jspf` 文件

### 6.4 静态包含与动态包含的选择

**问题描述：** 不确定何时使用静态包含，何时使用动态包含。

**解决方案：**
- **静态包含** (`<%@ include %>`)：适用于不经常变化的静态内容（页头、页脚、样式）
- **动态包含** (`<jsp:include>`)：适用于需要根据请求参数动态生成的内容

本实验中所有包含内容都是固定的，因此统一使用静态包含。

## 7 实验总结

通过本次实验，深入理解并掌握了以下 Java Web 开发核心技术：

### 7.1 Servlet 编程
- 掌握了 Servlet 的生命周期和基本编程模式
- 理解了 HTTP 请求处理方法（doGet、doPost）
- 学会了请求参数的获取与验证
- 掌握了请求转发与重定向的区别与应用场景

### 7.2 用户注册与数据持久化
- 实现了基于文件存储的用户注册系统
- 理解了 WEB-INF 目录的安全特性
- 掌握了账号唯一性验证的实现方法
- 学会了简单的数据读写操作

### 7.3 错误处理机制
- 掌握了 web.xml 中错误页面的配置方法
- 理解了 `<error-code>` 和 `<exception-type>` 的区别
- 学会了使用 `isErrorPage` 属性和 `exception` 隐式对象
- 能够设计友好的错误提示页面

### 7.4 JSP 包含指令与页面布局
- 掌握了静态包含 (`<%@ include %>`) 的使用方法
- 理解了静态包含与动态包含的区别与适用场景
- 学会了使用包含文件实现统一的页面布局
- 掌握了组件化设计思想，提高代码复用性

### 7.5 前端设计能力
- 能够设计美观的响应式网页布局
- 掌握了 CSS 渐变、阴影、动画等现代样式技术
- 理解了组件化前端开发的优势
- 学会了使用统一样式文件保持网站风格一致

### 7.6 AI 辅助开发
- 学会了如何编写有效的 AI 提示词
- 能够分析 AI 生成代码的优缺点
- 掌握了将 AI 辅助与传统学习相结合的方法
- 提升了代码审查和优化能力

通过本次实验，不仅掌握了 Java Web 开发的核心技术，还培养了良好的代码组织能力和系统设计思维，为后续更复杂的 Web 应用开发奠定了坚实基础。
