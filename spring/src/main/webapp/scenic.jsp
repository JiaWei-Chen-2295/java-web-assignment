<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Scenic Spots - Spring Campus Tourism</title>
  <%@ include file="includes/style.jspf" %>
</head>
<body>
  <%@ include file="includes/header.jspf" %>
  <%@ include file="includes/nav.jspf" %>

  <div class="container">
    <h2 class="section-title">Campus Scenic Spots</h2>
    <div class="card-grid">
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1523050854058-8df90110c8f1?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Cherry Blossom Avenue</h3>
          <p>A stunning corridor lined with cherry trees that bloom spectacularly every spring, creating a pink canopy perfect for photos and peaceful walks.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Main Library</h3>
          <p>The iconic central library features neo-classical architecture, grand reading rooms, and a collection of over 5 million volumes spanning centuries of knowledge.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1562774053-701939374585?w=600&q=80')"></div>
        <div class="card-body">
          <h3>University Hall</h3>
          <p>The historic main hall hosts ceremonies and events, featuring ornate interiors, stained glass windows, and a grand pipe organ dating from 1920.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1592280771190-3e2e4d571952?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Botanical Garden</h3>
          <p>Home to over 3,000 plant species from around the world, featuring themed gardens, a tropical greenhouse, and serene walking paths.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Memorial Clock Tower</h3>
          <p>Standing at 60 meters tall, the clock tower is a campus landmark visible from miles around, offering panoramic views from its observation deck.</p>
        </div>
      </div>
      <div class="card">
        <div class="card-img" style="background-image:url('https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=600&q=80')"></div>
        <div class="card-body">
          <h3>Science Building</h3>
          <p>A modern architectural marvel housing cutting-edge laboratories, a planetarium, and interactive science exhibitions open to visitors.</p>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
