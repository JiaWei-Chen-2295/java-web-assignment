<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>empty 运算符</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            min-height: 100vh;
            display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 620px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 28px; font-size: 24px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #eee; font-size: 14px; }
        th { background: #f5f0ff; color: #667eea; font-weight: 600; }
        .expr { font-family: "Consolas", monospace; color: #764ba2; }
        .result { font-weight: 600; color: #333; }
        .true { color: #2e7d32; }
        .false { color: #c62828; }
        .back { display: block; text-align: center; margin-top: 20px; color: #a18cd1; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%
        String emptyStr = "";
        String nullStr = null;
        String validStr = "Hello EL";
        String[] emptyArr = {};
        String[] validArr = {"a", "b"};
        List<String> emptyList = new ArrayList<>();
        List<String> validList = Arrays.asList("x", "y");
        Map<String, String> emptyMap = new HashMap<>();
        Map<String, String> validMap = new HashMap<>();
        validMap.put("key", "value");

        pageContext.setAttribute("emptyStr", emptyStr);
        pageContext.setAttribute("nullStr", nullStr);
        pageContext.setAttribute("validStr", validStr);
        pageContext.setAttribute("emptyArr", emptyArr);
        pageContext.setAttribute("validArr", validArr);
        pageContext.setAttribute("emptyList", emptyList);
        pageContext.setAttribute("validList", validList);
        pageContext.setAttribute("emptyMap", emptyMap);
        pageContext.setAttribute("validMap", validMap);
    %>
    <div class="container">
        <h1>EL empty 运算符</h1>
        <table>
            <tr><th>EL 表达式</th><th>结果</th></tr>
            <tr>
                <td class="expr">\${empty emptyStr}</td>
                <td class="result true">${empty emptyStr}</td>
            </tr>
            <tr>
                <td class="expr">\${empty nullStr}</td>
                <td class="result true">${empty nullStr}</td>
            </tr>
            <tr>
                <td class="expr">\${empty validStr}</td>
                <td class="result false">${empty validStr}</td>
            </tr>
            <tr>
                <td class="expr">\${empty emptyArr}</td>
                <td class="result true">${empty emptyArr}</td>
            </tr>
            <tr>
                <td class="expr">\${empty validArr}</td>
                <td class="result false">${empty validArr}</td>
            </tr>
            <tr>
                <td class="expr">\${empty emptyList}</td>
                <td class="result true">${empty emptyList}</td>
            </tr>
            <tr>
                <td class="expr">\${empty validList}</td>
                <td class="result false">${empty validList}</td>
            </tr>
            <tr>
                <td class="expr">\${empty emptyMap}</td>
                <td class="result true">${empty emptyMap}</td>
            </tr>
            <tr>
                <td class="expr">\${empty validMap}</td>
                <td class="result false">${empty validMap}</td>
            </tr>
            <tr>
                <td class="expr">\${not empty validStr}</td>
                <td class="result">${not empty validStr}</td>
            </tr>
        </table>
        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
