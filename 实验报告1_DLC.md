# Java Web 实验报告（DLC）

> 对应代码模块见：`showcase/src/main/resources/modules.yml`

## 1 实验目的

1. 掌握 HTML 表单提交与 Servlet 后台处理流程（注册功能）。
2. 掌握在 `web.xml` 中配置错误页面（404 / ArithmeticException / 500）。
3. 掌握 JSP 静态包含（`<%@ include %>`）与动态包含（`<jsp:include>`）的区别与用法，并用静态包含实现时间显示。
4. 通过“校园文化/春季旅游宣传站点”综合练习，使用包含文件统一主页面与二级页面布局。

## 2 实验环境

| 项目 | 说明 |
|------|------|
| 操作系统 | Windows 11 |
| 开发工具 | IntelliJ IDEA |
| Java 版本 | JDK 17+ |
| Web 容器 | Apache Tomcat 10+（Jakarta Servlet） |
| 构建工具 | Maven |

## 3 实验内容 10：用户注册（`ch05`）

### 3.1 需求

设计 `register.html` 注册页面；编写 `RegisterServlet` 接收表单数据并完成注册。

演示账号格式：**学号 + 姓名**（示例：`2023154202陈佳玮`）。

### 3.2 设计思路 / 算法

1. 前端表单 `POST` 提交 `account`、`password` 到 `/register`。
2. 后端获取参数并做非空校验。
3. 将用户信息写入服务器端 `WEB-INF/data/users.txt`（每行一条：`账号,密码`）。
4. 注册前读取文件逐行比较，若账号已存在则注册失败。
5. 成功跳转 `success.html`，失败跳转 `failure.html`。

### 3.3 关键文件

```text
ch05/src/main/webapp/register.html
ch05/src/main/java/fun/javierchen/ch05/RegisterServlet.java
ch05/src/main/webapp/WEB-INF/web.xml
ch05/src/main/webapp/success.html
ch05/src/main/webapp/failure.html
```

### 3.4 运行截图（请自行替换为你的截图）

- 图3-1 注册页面：访问 `http://localhost:8080/ch05/register.html`
- 图3-2 注册成功：提交新账号后跳转 `success.html`
- 图3-3 注册失败：重复账号或空参数跳转 `failure.html`

（建议截图保存到：`./assets/ch05-register.png`、`./assets/ch05-success.png`、`./assets/ch05-failure.png`，并在此处引用）

## 4 实验内容 11：错误页面配置（`ch08`）

### 4.1 需求

为项目添加 `web.xml` 并配置错误处理页面，覆盖：

1. **404**：请求资源不存在
2. **ArithmeticException**：算数运算错误（如除零）
3. **500**：服务器程序错误（未捕获异常导致）

### 4.2 实现思路

在 `web.xml` 使用 `<error-page>` 做映射：

- 通过 `<error-code>` 映射 HTTP 状态码（如 `404`、`500`）
- 通过 `<exception-type>` 映射 Java 异常类（如 `java.lang.ArithmeticException`）
- `<location>` 指向错误页 JSP（一般以 `/` 开头，表示相对 Web 应用根路径）

本实验代码位置：`ch08/src/main/webapp/WEB-INF/web.xml`。

### 4.3 触发方式

- 404：访问不存在资源，例如 `http://localhost:8080/ch08/not-exist.html`
- ArithmeticException：访问 `http://localhost:8080/ch08/error.jsp`（内部除零）
- 500：访问 `http://localhost:8080/ch08/trigger500.jsp`（内部空指针）

### 4.4 AI 工具咨询记录（ctx7）

本节按要求使用 `ctx7` 查询（节选记录）：

1) 查询库（命令）：

```bash
npx ctx7@latest library "jakarta servlet" "在web.xml如何配置错误页面，处理类型：文件404，算数运算错误，服务器程序错误"
```

选择结果：`/websites/tomcat_apache_tomcat-10_1-doc`（Tomcat 10.1 官方文档聚合，信誉 High，得分 83.3）。

2) 查询文档（命令）：

```bash
npx ctx7@latest docs /websites/tomcat_apache_tomcat-10_1-doc "web.xml <error-page> error-code exception-type location"
```

ctx7 返回内容要点（节选）：
- Tomcat 的 `ErrorPage` 配置项包含：`errorCode`、`exceptionType`、`location`
- `setErrorCode(...)` / `setExceptionType(...)` 等 API 说明了错误页映射的三个核心字段

> 说明：ctx7 本次返回更偏 API 侧的 `ErrorPage` 结构信息，但与课件中 `<error-page>` 的三个核心字段（错误码/异常类型/页面位置）是一致的。

### 4.5 与课件内容对比（总结）

| 对比点 | 课件要点（概括） | 本实验实现 |
|---|---|---|
| 404 处理 | 用 `<error-code>404</error-code>` | `error404.jsp` |
| 异常处理 | 用 `<exception-type>` 精确匹配异常类 | `java.lang.ArithmeticException` → `errorArithmetic.jsp` |
| 500 处理 | 用 `<error-code>500</error-code>` 兜底 | `error500.jsp` |
| 页面属性 | 错误页可用 `isErrorPage="true"` 获取 `exception` | 错误页均设置 `isErrorPage="true"` |

### 4.6 运行截图（请自行替换为你的截图）

- 图4-1 404 错误页
- 图4-2 算术异常错误页
- 图4-3 500 错误页

## 5 实验内容 12：JSP 静态包含 / 动态包含（`JSP-directive`）

### 5.1 需求

1. 下载并使用图片资源；
2. 完成静态包含与动态包含示例；
3. **使用静态包含实现时间显示**。

### 5.2 实现思路

- 静态包含：`static-include.jsp` 使用 `<%@ include file="header.jspf" %>` 与 `<%@ include file="student-info.jspf" %>`。
  - `student-info.jspf` 内部用 `LocalDateTime` 输出当前时间，实现“静态包含 + 时间显示”要求。
- 动态包含：`dynamic-include.jsp` 使用 `<jsp:include page="dynamic-image.jsp" />` 与 `<jsp:include page="server-time.jsp" />`，在运行期输出片段内容。

### 5.3 关键文件

```text
JSP-directive/src/main/webapp/index.jsp
JSP-directive/src/main/webapp/static-include.jsp
JSP-directive/src/main/webapp/dynamic-include.jsp
JSP-directive/src/main/webapp/header.jspf
JSP-directive/src/main/webapp/student-info.jspf
JSP-directive/src/main/webapp/dynamic-image.jsp
JSP-directive/src/main/webapp/server-time.jsp
JSP-directive/src/main/webapp/images/static-image.jpg
JSP-directive/src/main/webapp/images/dynamic-image.jpg
```

### 5.4 运行截图（请自行替换为你的截图）

- 图5-1 `index.jsp` 入口页面
- 图5-2 `static-include.jsp`（展示静态包含与“当前时间”）
- 图5-3 `dynamic-include.jsp`（展示动态包含片段）

## 6 实验内容 13：校园文化/春季旅游宣传页面（`spring`）

### 6.1 需求

设计一个宣传校园文化旅游或春天旅游的页面，包含：

- 1 个主页面
- 4 个二级导航页面
- 主页面与二级页面通过包含文件统一布局（页头/导航/页脚等）
- 主页面至少 4 个导航链接，页面样式美观

### 6.2 页面结构与包含设计

主页面：`spring/src/main/webapp/index.jsp`

二级页面（4 个）：（示例）

- `spring/src/main/webapp/scenic.jsp`
- `spring/src/main/webapp/culture.jsp`
- `spring/src/main/webapp/routes.jsp`
- `spring/src/main/webapp/about.jsp`
（另有 `contact.jsp` 作为补充页）

统一布局包含文件：

```text
spring/src/main/webapp/includes/header.jspf
spring/src/main/webapp/includes/nav.jspf
spring/src/main/webapp/includes/footer.jspf
spring/src/main/webapp/includes/style.jspf
spring/src/main/webapp/includes/slider.jspf
```

主/子页面通过 `<%@ include file="includes/*.jspf" %>` 引入同一套页头、导航与页脚，从而保证风格与布局一致。

### 6.3 运行截图（请自行替换为你的截图）

- 图6-1 主页面（含 4+ 导航链接）
- 图6-2 二级页面 1（景点）
- 图6-3 二级页面 2（文化）
- 图6-4 二级页面 3（路线）
- 图6-5 二级页面 4（关于）

## 7 项目文件结构（概览）

```text
java-web/
├─ showcase/src/main/resources/modules.yml   # 作业展示入口配置
├─ ch05/                                    # 注册/登录
├─ ch08/                                    # web.xml 错误页
├─ JSP-directive/                           # JSP 包含（静态/动态）
└─ spring/                                  # 旅游宣传站点（含 includes）
```

## 8 使用的 AI 提示词（记录）

### 8.1 注册模块提示词（示例）

```text
请帮我实现 Java Web 用户注册功能：
1) 前端 register.html，账号格式为“学号+姓名”
2) 后端 RegisterServlet 处理 POST
3) 账号重复则失败，成功则跳转 success.html
4) 用户信息保存到 WEB-INF/data/users.txt
```

### 8.2 web.xml 错误页提示词（本实验实际用到）

```text
在 web.xml 如何配置错误页面，处理类型：文件404，算数运算错误(ArithmeticException)，服务器程序错误(500)？
请给出 <error-page> 配置示例，并说明 <error-code> 与 <exception-type> 的区别，以及 location 路径写法要求。
```

### 8.3 JSP 包含提示词（示例）

```text
请给出 JSP 静态包含 <%@ include %> 与动态包含 <jsp:include> 的示例，
并要求：静态包含页面中显示当前时间，动态包含页面可用 jsp:include 输出一个片段。
```

### 8.4 旅游宣传页提示词（示例）

```text
请设计一个“校园文化/春天旅游”宣传站点：
1 个主页面 + 4 个二级页面，统一头部/导航/页脚为 include 文件，
主页面提供至少 4 个导航链接，页面风格简洁美观。
```

## 9 实验总结

本次实验完成了注册功能、错误页配置、JSP 包含练习以及综合宣传页面设计，进一步理解了 Java Web 中：

- 表单提交 → Servlet 处理 → 文件持久化存储的基本流程
- `web.xml` 错误页映射（状态码/异常类型）与 JSP 错误页页面属性
- JSP 静态/动态包含的执行阶段差异与适用场景
- 通过 include 文件实现多页面统一布局的工程化组织方式

