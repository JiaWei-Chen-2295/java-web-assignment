<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    String currentTime = now.format(formatter);
%>
<div style="background: #f0f7ff; border-left: 4px solid #0066cc; padding: 20px 25px; margin: 30px 0; border-radius: 0 4px 4px 0;">
    <h3 style="color: #1a1a1a; font-weight: 500; margin-bottom: 15px; font-size: 1em; text-transform: uppercase; letter-spacing: 0.5px;">学生信息</h3>
    <table style="border-collapse: collapse; width: 100%;">
        <tr>
            <td style="padding: 6px 0; color: #555; width: 80px;">学号：</td>
            <td style="padding: 6px 0; color: #1a1a1a; font-weight: 500;">2023154202</td>
        </tr>
        <tr>
            <td style="padding: 6px 0; color: #555;">姓名：</td>
            <td style="padding: 6px 0; color: #1a1a1a; font-weight: 500;">陈佳玮</td>
        </tr>
        <tr>
            <td style="padding: 6px 0; color: #555;">当前时间：</td>
            <td style="padding: 6px 0; color: #1a1a1a; font-weight: 500;"><%= currentTime %></td>
        </tr>
    </table>
</div>
