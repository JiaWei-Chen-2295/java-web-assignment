<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Include - JSP Action</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
            background: #ffffff;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 980px;
            margin: 0 auto;
            padding: 60px 20px;
        }
        
        .page-header {
            margin-bottom: 50px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .page-header h1 {
            font-size: 2.5em;
            font-weight: 300;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .info-box {
            background: #fafafa;
            border-left: 3px solid #0066cc;
            padding: 25px;
            margin: 30px 0;
        }
        
        .info-box h3 {
            color: #1a1a1a;
            margin-bottom: 12px;
            font-weight: 500;
        }
        
        .info-box p {
            color: #555;
            line-height: 1.7;
        }
        
        .image-section {
            text-align: center;
            margin: 40px 0;
            padding: 40px;
            background: #fafafa;
            border-radius: 4px;
        }
        
        .image-section img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        
        .image-section h3 {
            color: #1a1a1a;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .image-section p {
            color: #666;
            font-style: italic;
        }
        
        .code-block {
            background: #2d2d2d;
            color: #f8f8f2;
            padding: 25px;
            border-radius: 4px;
            overflow-x: auto;
            margin: 30px 0;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.9em;
            line-height: 1.6;
        }
        
        .highlight {
            color: #ffd700;
        }
        
        h3 {
            color: #1a1a1a;
            font-weight: 500;
            margin: 40px 0 20px 0;
        }
        
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 30px 0;
        }
        
        .feature-item {
            background: #fafafa;
            padding: 25px;
            border-radius: 4px;
        }
        
        .feature-item h4 {
            color: #1a1a1a;
            margin-bottom: 10px;
            font-weight: 500;
        }
        
        .feature-item p {
            color: #555;
            line-height: 1.6;
            font-size: 0.95em;
        }
        
        .back-link {
            display: inline-block;
            color: #0066cc;
            text-decoration: none;
            font-weight: 500;
            margin-top: 30px;
            padding: 10px 0;
            border-bottom: 2px solid transparent;
            transition: border-color 0.3s;
        }
        
        .back-link:hover {
            border-bottom-color: #0066cc;
        }
        
        code {
            color: #0066cc;
            background: #fafafa;
            padding: 3px 8px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
        }
    </style>
</head>
<body>
    <%@ include file="header.jspf" %>
    
    <div class="container">
        <div class="page-header">
            <h1>Dynamic Include Example</h1>
        </div>
        
        <div class="info-box">
            <h3>📌 Dynamic Include (<code>&lt;jsp:include page="..." /&gt;</code>)</h3>
            <p>
                The dynamic include action includes the output of another resource during the request processing phase (runtime). 
                Each included resource is executed independently and its output is inserted into the response. 
                This is also known as a <strong>runtime include</strong>.
            </p>
        </div>
        
        <div class="image-section">
            <h3 style="color: #555; margin-bottom: 15px;">Included Image (Dynamic)</h3>
            <jsp:include page="images/dynamic-image.jpg" />
            <p style="color: #666; margin-top: 15px; font-style: italic;">
                This image is included using dynamic include action - processed at request time
            </p>
        </div>
        
        <h3 style="color: #555; margin: 30px 0 15px 0;">Code Example:</h3>
        <div class="code-block">
&lt;%-- Static include for header (translation time) --%&gt;
<span class="highlight">&lt;%@ include file="header.jspf" %&gt;</span>

&lt;%-- Dynamic include for image (request time) --%&gt;
<span class="highlight">&lt;jsp:include page="images/dynamic-image.jpg" /&gt;</span>
        </div>
        
        <h3 style="color: #555; margin: 30px 0 15px 0;">Key Characteristics:</h3>
        <div class="feature-grid">
            <div class="feature-item">
                <h4>⏱️ Runtime Execution</h4>
                <p>Content is included during request processing, not at translation time</p>
            </div>
            <div class="feature-item">
                <h4>🔄 Independent Processing</h4>
                <p>Each included resource executes separately and produces its own output</p>
            </div>
            <div class="feature-item">
                <h4>🎯 Dynamic Content</h4>
                <p>Perfect for including content that changes based on request parameters</p>
            </div>
            <div class="feature-item">
                <h4>⚡ Flexibility</h4>
                <p>The page to include can be determined dynamically using expressions</p>
            </div>
        </div>
        
        <h3 style="color: #555; margin: 30px 0 15px 0;">Advanced Usage:</h3>
        <div class="code-block">
&lt;%-- Dynamic include with parameters --%&gt;
&lt;jsp:include page="dynamic-content.jsp"&gt;
    &lt;jsp:param name="userId" value="123" /&gt;
    &lt;jsp:param name="theme" value="dark" /&gt;
&lt;/jsp:include&gt;

&lt;%-- Dynamic include with expression --%&gt;
&lt;jsp:include page="&lt;%= someVariable %&gt;" /&gt;
        </div>
        
        <a href="index.jsp" class="back-link">← Back to Home</a>
    </div>
</body>
</html>
