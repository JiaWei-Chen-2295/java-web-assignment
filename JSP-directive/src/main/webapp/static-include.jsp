<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Static Include - JSP Directive</title>
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
        
        ul {
            list-style: none;
            margin: 20px 0;
        }
        
        ul li {
            padding: 10px 0;
            padding-left: 25px;
            position: relative;
            color: #555;
        }
        
        ul li:before {
            content: "•";
            position: absolute;
            left: 0;
            color: #0066cc;
            font-size: 1.2em;
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
    <%@ include file="student-info.jspf" %>
    
    <div class="container">
        <div class="page-header">
            <h1>Static Include Example</h1>
        </div>
        
        <div class="info-box">
            <h3>📌 Static Include (<code>&lt;%@ include file="..." %&gt;</code>)</h3>
            <p>
                The static include directive includes the content of another file during the translation phase (when JSP is converted to servlet). 
                The included file's content is literally copied and pasted into the including JSP file before compilation. 
                This is also known as a <strong>compile-time include</strong>.
            </p>
        </div>
        
        <div class="image-section">
            <h3 style="color: #555; margin-bottom: 15px;">Included Image (Static)</h3>
            <img src="images/static-image.jpg" alt="Static Include Image" style="max-width: 100%; height: auto; border-radius: 4px; margin-bottom: 15px;">
            <p style="color: #666; margin-top: 15px; font-style: italic;">
                This image is referenced as a normal static resource. The page layout (header/student info) uses static include.
            </p>
        </div>
        
        <h3 style="color: #555; margin: 30px 0 15px 0;">Code Example:</h3>
        <div class="code-block">
&lt;%-- Static include using JSP directive --%&gt;
<span class="highlight">&lt;%@ include file="header.jspf" %&gt;</span>

&lt;%-- Static include: student info (student ID, name, current time) --%&gt;
<span class="highlight">&lt;%@ include file="student-info.jspf" %&gt;</span>

&lt;%-- Image as static resource reference --%&gt;
&lt;img src="images/static-image.jpg" ... /&gt;
        </div>
        
        <h3 style="color: #555; margin: 30px 0 15px 0;">Key Characteristics:</h3>
        <ul style="line-height: 2; color: #555; margin-left: 20px;">
            <li><strong>Translation Time:</strong> Content is included when JSP is translated to servlet</li>
            <li><strong>File Merging:</strong> Multiple files are merged into one servlet</li>
            <li><strong>No Runtime Overhead:</strong> No additional processing at request time</li>
            <li><strong>Static Binding:</strong> Changes to included files require recompilation</li>
            <li><strong>Best For:</strong> Static content like headers, footers, templates</li>
        </ul>
        
        <a href="index.jsp" class="back-link">← Back to Home</a>
    </div>
</body>
</html>
