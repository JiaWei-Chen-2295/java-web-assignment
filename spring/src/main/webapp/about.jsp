<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About Us - Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>
</head>
<body>
  <%@ include file="includes/header.jspf" %>
  <%@ include file="includes/nav.jspf" %>

  <div class="container">
    <h2 class="section-title">About Us</h2>
    <div class="three-col">
      <div class="sidebar">
        <h3>Our Mission</h3>
        <p style="color:#666; line-height:1.8;">To share the beauty and heritage of our campus with visitors from around the world, promoting understanding of academic traditions and cultural values.</p>
      </div>

      <div class="main-content">
        <h3 style="color:#2e7d32; margin-bottom:15px;">Our Story</h3>
        <p style="margin-bottom:15px;">Spring Campus Tourism was established to showcase the unique beauty and rich heritage of our university campus. What began as informal tours by enthusiastic students has grown into a professional tourism service welcoming thousands of visitors annually.</p>

        <p style="margin-bottom:15px;">Our team consists of passionate guides, historians, horticulturists, and hospitality professionals dedicated to providing memorable experiences for every visitor. We believe that our campus is not just a place of learning, but a living museum of architecture, nature, and human achievement.</p>

        <h3 style="color:#2e7d32; margin:25px 0 15px;">What We Offer</h3>
        <p style="margin-bottom:10px;">&#9989; Expert-led guided tours in multiple languages</p>
        <p style="margin-bottom:10px;">&#9989; Self-guided tour materials and mobile apps</p>
        <p style="margin-bottom:10px;">&#9989; Seasonal special events and exhibitions</p>
        <p style="margin-bottom:10px;">&#9989; Educational programs for schools and groups</p>
        <p style="margin-bottom:10px;">&#9989; Photography workshops and guided walks</p>

        <h3 style="color:#2e7d32; margin:25px 0 15px;">By The Numbers</h3>
        <div class="feature-list" style="grid-template-columns: repeat(3, 1fr); margin-top:15px;">
          <div class="feature">
            <div class="feature-icon">&#128101;</div>
            <h4>50,000+</h4>
            <p>Annual Visitors</p>
          </div>
          <div class="feature">
            <div class="feature-icon">&#127963;</div>
            <h4>100+</h4>
            <p>Historic Buildings</p>
          </div>
          <div class="feature">
            <div class="feature-icon">&#127795;</div>
            <h4>200 Acres</h4>
            <p>Green Spaces</p>
          </div>
        </div>
      </div>

      <div class="sidebar">
        <h3>Quick Facts</h3>
        <ul>
          <li><strong>Founded:</strong> 2010</li>
          <li><strong>Team Size:</strong> 25+ guides</li>
          <li><strong>Languages:</strong> 8</li>
          <li><strong>Tours/Day:</strong> 6</li>
          <li><strong>Rating:</strong> 4.9/5</li>
        </ul>
      </div>
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
