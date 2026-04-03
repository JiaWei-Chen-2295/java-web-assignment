<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>触发 500 错误</title>
</head>
<body>
    <h2>触发 500 服务器错误示例</h2>
    <%
        // 故意抛出 NullPointerException
        // web.xml 中没有配置该异常类型，容器将其转为 HTTP 500
        // 从而跳转到 <error-code>500</error-code> 指定的 error500.jsp
        String str = null;
        int len = str.length();
    %>
    <p>此行不会被执行。</p>
</body>
</html>
