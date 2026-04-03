<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>
</head>
<body>
  <%@ include file="includes/header.jspf" %>
  <%@ include file="includes/nav.jspf" %>

  <div class="container">
    <%@ include file="includes/slider.jspf" %>

    <h2 class="section-title">Campus Highlights</h2>
    <div class="feature-list">
      <div class="feature">
        <div class="feature-icon">&#127800;</div>
        <h4>Cherry Blossoms</h4>
        <p>Beautiful spring blooms across campus</p>
      </div>
      <div class="feature">
        <div class="feature-icon">&#127963;</div>
        <h4>Historic Buildings</h4>
        <p>Centuries of academic heritage</p>
      </div>
      <div class="feature">
        <div class="feature-icon">&#128218;</div>
        <h4>Famous Library</h4>
        <p>Millions of books and resources</p>
      </div>
      <div class="feature">
        <div class="feature-icon">&#127795;</div>
        <h4>Gardens & Parks</h4>
        <p>Peaceful green spaces to explore</p>
      </div>
    </div>

    <div class="three-col">
      <div class="sidebar">
        <h3>Quick Links</h3>
        <ul>
          <li><a href="scenic.jsp">Scenic Spots</a></li>
          <li><a href="culture.jsp">Campus Culture</a></li>
          <li><a href="routes.jsp">Tour Routes</a></li>
          <li><a href="about.jsp">About Us</a></li>
          <li><a href="contact.jsp">Contact</a></li>
        </ul>
      </div>

      <div class="main-content">
        <h2 style="color:#2e7d32; margin-bottom:20px;">Welcome to Spring Campus</h2>
        <p style="margin-bottom:15px;">Experience the beauty of our campus during the most wonderful season of the year. Spring brings cherry blossoms, fresh green leaves, and a vibrant atmosphere perfect for exploration.</p>
        <p style="margin-bottom:15px;">Our campus features historic architecture dating back over a century, modern research facilities, beautiful gardens, and a rich cultural heritage that attracts visitors from around the world.</p>
        <p style="margin-bottom:25px;">Whether you are a prospective student, alumni, or simply a visitor, we invite you to discover the unique charm that makes our university special.</p>
        <a href="scenic.jsp" class="btn">Explore Now</a>
      </div>

      <div class="sidebar">
        <h3>Latest News</h3>
        <ul>
          <li><a href="#">Spring Festival Events 2024</a></li>
          <li><a href="#">New Garden Area Open</a></li>
          <li><a href="#">Alumni Reunion Coming</a></li>
          <li><a href="#">Photo Contest Winners</a></li>
        </ul>
      </div>
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
