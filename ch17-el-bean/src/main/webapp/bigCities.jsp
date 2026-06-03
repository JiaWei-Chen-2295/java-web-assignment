<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSTL forEach 迭代 Map</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fdfcfb 100%);
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255,255,255,0.95); border-radius: 16px;
            padding: 40px; max-width: 700px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        h1 { text-align: center; color: #333; margin-bottom: 12px; font-size: 24px; }
        .subtitle { text-align: center; color: #888; font-size: 13px; margin-bottom: 28px; }
        .section {
            border-radius: 10px; padding: 24px;
            margin-bottom: 24px; border: 1px solid #e0e0e0;
        }
        .section.cap { background: #fff3e0; }
        .section.cities { background: #e8f5e9; }
        .section h3 { margin-bottom: 16px; font-size: 16px; }
        .section.cap h3 { color: #e65100; }
        .section.cities h3 { color: #2e7d32; }
        table { width: 100%; border-collapse: collapse; }
        th, td {
            padding: 10px 14px; text-align: left; font-size: 14px;
            border-bottom: 1px solid rgba(0,0,0,0.06);
        }
        th { font-weight: 600; }
        .section.cap th { color: #bf360c; background: rgba(255,152,0,0.1); }
        .section.cities th { color: #1b5e20; background: rgba(76,175,80,0.1); }
        .tag { font-family: "Consolas", monospace; font-size: 12px; color: #999; background: #f5f5f5; padding: 2px 6px; border-radius: 3px; }
        .back { display: block; text-align: center; margin-top: 24px; color: #e65100; text-decoration: none; font-size: 14px; }
        .back:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>JSTL &lt;c:forEach&gt; 迭代 Map</h1>
        <p class="subtitle">BigCitiesServlet 设置两个 Map，使用 EL + JSTL 标签遍历输出</p>

        <div class="section cap">
            <h3>Map&lt;String, String&gt; 国家 → 首都</h3>
            <table>
                <tr>
                    <th>#</th>
                    <th>国家 (key)</th>
                    <th>首都 (value)</th>
                </tr>
                <c:forEach var="entry" items="${capitals}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${entry.key}</td>
                    <td>${entry.value}</td>
                </tr>
                </c:forEach>
            </table>
        </div>

        <div class="section cities">
            <h3>Map&lt;String, String[]&gt; 国家 → 大城市</h3>
            <table>
                <tr>
                    <th>#</th>
                    <th>国家 (key)</th>
                    <th>大城市 (value)</th>
                </tr>
                <c:forEach var="entry" items="${bigCities}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${entry.key}</td>
                    <td>
                        <c:forEach var="city" items="${entry.value}" varStatus="cs">
                            ${city}<c:if test="${!cs.last}">、</c:if>
                        </c:forEach>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>

        <a class="back" href="${pageContext.request.contextPath}/">返回首页</a>
    </div>
</body>
</html>
