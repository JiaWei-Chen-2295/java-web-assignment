<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户列表 — JDBC + Servlet 演示</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', system-ui, sans-serif; background: #f0f2f5; color: #333; }
    .container { max-width: 960px; margin: 60px auto; padding: 0 20px; }
    h1 { text-align: center; margin-bottom: 8px; font-size: 28px; }
    .subtitle { text-align: center; color: #666; margin-bottom: 32px; font-size: 14px; }
    .error-box { background: #fff2f0; border: 1px solid #ffccc7; border-radius: 8px; padding: 16px; margin-bottom: 24px; color: #cf1322; }
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    th, td { padding: 14px 18px; text-align: left; }
    th { background: #1677ff; color: #fff; font-weight: 600; }
    td { border-bottom: 1px solid #f0f0f0; }
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: #e6f4ff; }
    .empty { text-align: center; padding: 48px; color: #999; }
    .btn-wrap { text-align: center; margin-top: 28px; }
    .btn { display: inline-block; padding: 10px 28px; background: #1677ff; color: #fff; text-decoration: none; border-radius: 6px; font-size: 15px; transition: background .2s; }
    .btn:hover { background: #4096ff; }
  </style>
</head>
<body>
<div class="container">
  <h1>Users 表数据</h1>
  <p class="subtitle">通过 JDBC 查询 MySQL，Servlet 转发至 JSP 展示</p>

  <c:if test="${not empty error}">
    <div class="error-box">${error}</div>
  </c:if>

  <c:choose>
    <c:when test="${empty userList}">
      <p class="empty">暂无数据，请先执行 sql/init.sql 初始化表并插入数据。</p>
    </c:when>
    <c:otherwise>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>邮箱</th>
            <th>年龄</th>
            <th>创建时间</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${userList}" var="user">
            <tr>
              <td>${user.id}</td>
              <td>${user.name}</td>
              <td>${user.email}</td>
              <td>${user.age}</td>
              <td>${user.created}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>

  <div class="btn-wrap">
    <a class="btn" href="users">刷新数据</a>
  </div>
</div>
</body>
</html>
