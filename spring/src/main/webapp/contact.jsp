<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact - Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>
</head>
<body>
  <%@ include file="includes/header.jspf" %>
  <%@ include file="includes/nav.jspf" %>

  <div class="container">
    <h2 class="section-title">Contact Us</h2>
    <div class="three-col">
      <div class="sidebar">
        <h3>Contact Info</h3>
        <ul>
          <li><strong>Address:</strong><br>123 University Ave</li>
          <li><strong>Phone:</strong><br>+1 (555) 123-4567</li>
          <li><strong>Email:</strong><br>tour@university.edu</li>
          <li><strong>Hours:</strong><br>Mon-Sun 8AM-6PM</li>
        </ul>
      </div>

      <div class="main-content">
        <h3 style="color:#2e7d32; margin-bottom:20px;">Send Us a Message</h3>
        <form style="max-width:500px;">
          <div style="margin-bottom:20px;">
            <label style="display:block; margin-bottom:5px; color:#555; font-weight:500;">Name</label>
            <input type="text" style="width:100%; padding:12px; border:2px solid #e0e0e0; border-radius:8px; font-size:1em; transition:border-color 0.3s;" placeholder="Your name">
          </div>
          <div style="margin-bottom:20px;">
            <label style="display:block; margin-bottom:5px; color:#555; font-weight:500;">Email</label>
            <input type="email" style="width:100%; padding:12px; border:2px solid #e0e0e0; border-radius:8px; font-size:1em; transition:border-color 0.3s;" placeholder="Your email">
          </div>
          <div style="margin-bottom:20px;">
            <label style="display:block; margin-bottom:5px; color:#555; font-weight:500;">Subject</label>
            <select style="width:100%; padding:12px; border:2px solid #e0e0e0; border-radius:8px; font-size:1em; background:white;">
              <option>General Inquiry</option>
              <option>Tour Booking</option>
              <option>Group Reservation</option>
              <option>Feedback</option>
            </select>
          </div>
          <div style="margin-bottom:25px;">
            <label style="display:block; margin-bottom:5px; color:#555; font-weight:500;">Message</label>
            <textarea rows="5" style="width:100%; padding:12px; border:2px solid #e0e0e0; border-radius:8px; font-size:1em; resize:vertical;" placeholder="Your message"></textarea>
          </div>
          <button type="button" class="btn">Send Message</button>
        </form>
      </div>

      <div class="sidebar">
        <h3>Location</h3>
        <div style="background:#e8f5e9; height:200px; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#2e7d32; font-size:0.9em;">
          Map Placeholder
        </div>
        <h3 style="margin-top:20px;">Follow Us</h3>
        <ul>
          <li><a href="#">WeChat</a></li>
          <li><a href="#">Weibo</a></li>
          <li><a href="#">Instagram</a></li>
          <li><a href="#">Twitter</a></li>
        </ul>
      </div>
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
