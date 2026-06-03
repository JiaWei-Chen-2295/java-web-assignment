<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    String currentTime = now.format(formatter);
%>
<div style="background: #fff7e6; border-left: 4px solid #ff9800; padding: 18px 22px; margin: 30px 0; border-radius: 0 4px 4px 0;">
    <strong style="color:#1a1a1a;">动态包含（运行期）时间：</strong>
    <span style="color:#1a1a1a; font-weight: 600;"><%= currentTime %></span>
    <div style="color:#666; margin-top:6px; font-size: 12px;">
        通过 &lt;jsp:include&gt; 在请求处理阶段执行并输出。
    </div>
</div>

