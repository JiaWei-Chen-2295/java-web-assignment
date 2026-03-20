# Java Web 开发 
开发者：

(陈佳玮)JavierChen @2023154202
(陈建宇)JianYu Chen @2023154201

## ch05 - 用户注册与登录模块

### 功能
- HTML 注册页面（账号：学号+名字，密码）
- Servlet 处理注册/登录逻辑
- 本地文件存储账号密码（WEB-INF/data/users.txt）
- 四种 action 路径方式演示

### 访问
- 注册页面：http://localhost:8080/ch05/register.html
- 登录页面（四种路径方式）：
  - login1_contextpath.jsp - `${pageContext.request.contextPath}/login`
  - login2_relative.jsp - `login`
  - login3_server_relative.jsp - `/ch05/login`
  - login4_page_relative.jsp - `./login`

### 接口
- POST /register - 注册
- POST /login - 登录（成功返回时间，失败返回"登录失败"）