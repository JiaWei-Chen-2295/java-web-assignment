<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tour Routes - Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>
</head>
<body>
  <%@ include file="includes/header.jspf" %>
  <%@ include file="includes/nav.jspf" %>

  <div class="container">
    <h2 class="section-title">Recommended Tour Routes</h2>
    <div class="card-grid">
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Classic Campus Tour (2h)</h3>
          <p>Main Gate &#8594; Cherry Avenue &#8594; Library &#8594; University Hall &#8594; Clock Tower &#8594; Garden. Perfect for first-time visitors.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1562774053-701939374585?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Architecture Tour (3h)</h3>
          <p>Gothic Library &#8594; Art Deco Hall &#8594; Modern Science Center &#8594; Historic Dormitories &#8594; Contemporary Art Museum.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1592280771190-3e2e4d571952?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Nature Walk (1.5h)</h3>
          <p>Botanical Garden &#8594; Duck Pond &#8594; Bamboo Grove &#8594; Rose Garden &#8594; Arboretum. Ideal for nature lovers.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=600&q=80')"></div>
        <div class="card-body">
          <h3>History Tour (4h)</h3>
          <p>Founding Hall &#8594; War Memorial &#8594; Archives &#8594; Heritage Museum &#8594; Pioneer Cemetery. Deep dive into history.</p>
        </div>
      </div>
    </div>

    <h2 class="section-title">Tour Information</h2>
    <div class="main-content" style="max-width:800px; margin:0 auto;">
      <p style="margin-bottom:15px;"><strong>Guided Tours:</strong> Available daily at 10:00 AM and 2:00 PM, departing from the Main Gate Visitor Center.</p>
      <p style="margin-bottom:15px;"><strong>Self-Guided Tours:</strong> Download our free mobile app with audio guides and interactive maps.</p>
      <p style="margin-bottom:15px;"><strong>Group Bookings:</strong> Contact us for customized tours for groups of 10 or more.</p>
      <p><strong>Accessibility:</strong> All major routes are wheelchair accessible. Contact us for special assistance.</p>
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
