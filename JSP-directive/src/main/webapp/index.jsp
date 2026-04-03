<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Include Directives</title>
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
        
        .main-container {
            max-width: 980px;
            margin: 0 auto;
            padding: 60px 20px;
        }
        
        .header-section {
            margin-bottom: 60px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .header-section h1 {
            font-size: 2.5em;
            font-weight: 300;
            color: #1a1a1a;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }
        
        .header-section p {
            font-size: 1.1em;
            color: #666;
            font-weight: 300;
        }
        
        .content-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 40px;
            margin-bottom: 60px;
        }
        
        .section-card {
            background: #fafafa;
            padding: 40px;
            border-left: 3px solid #0066cc;
            transition: all 0.3s ease;
        }
        
        .section-card:hover {
            background: #f5f5f5;
            transform: translateX(5px);
        }
        
        .section-card h2 {
            font-size: 1.5em;
            font-weight: 400;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .code-snippet {
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.9em;
            color: #0066cc;
            background: #fff;
            padding: 10px 15px;
            border-radius: 3px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .image-preview {
            width: 100%;
            height: 180px;
            object-fit: cover;
            margin: 20px 0;
            border-radius: 4px;
            background: #fff;
        }
        
        .feature-list {
            list-style: none;
            margin: 20px 0;
        }
        
        .feature-list li {
            padding: 8px 0;
            color: #555;
            font-size: 0.95em;
            padding-left: 20px;
            position: relative;
        }
        
        .feature-list li:before {
            content: "•";
            position: absolute;
            left: 0;
            color: #0066cc;
            font-size: 1.2em;
        }
        
        .action-link {
            display: inline-block;
            color: #0066cc;
            text-decoration: none;
            font-weight: 500;
            margin-top: 15px;
            padding: 8px 0;
            border-bottom: 2px solid transparent;
            transition: border-color 0.3s;
        }
        
        .action-link:hover {
            border-bottom-color: #0066cc;
        }
        
        .comparison-section {
            margin-top: 60px;
            padding-top: 40px;
            border-top: 2px solid #f0f0f0;
        }
        
        .comparison-section h2 {
            font-size: 1.8em;
            font-weight: 300;
            color: #1a1a1a;
            margin-bottom: 30px;
        }
        
        .comparison-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95em;
        }
        
        .comparison-table th,
        .comparison-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .comparison-table th {
            font-weight: 500;
            color: #1a1a1a;
            background: #fafafa;
        }
        
        .comparison-table tr:hover {
            background: #fafafa;
        }
        
        .footer {
            margin-top: 60px;
            padding-top: 30px;
            border-top: 1px solid #f0f0f0;
            text-align: center;
            color: #999;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <%@ include file="header.jspf" %>
    
    <div class="main-container">
        <div class="header-section">
            <h1>JSP Include Directives</h1>
            <p>Understanding static and dynamic content inclusion in JSP</p>
        </div>
        
        <div class="content-grid">
            <!-- Static Include Section -->
            <div class="section-card">
                <h2>Static Include</h2>
                <div class="code-snippet">&lt;%@ include file="..." %&gt;</div>
                
                <img src="images/static-image.jpg" alt="Static Example" class="image-preview">
                
                <ul class="feature-list">
                    <li>Translation-time inclusion (compile-time)</li>
                    <li>Content literally copied into JSP</li>
                    <li>No runtime overhead</li>
                    <li>Best for static content like headers/footers</li>
                    <li>Changes require recompilation</li>
                </ul>
                
                <a href="static-include.jsp" class="action-link">View Example →</a>
            </div>
            
            <!-- Dynamic Include Section -->
            <div class="section-card">
                <h2>Dynamic Include</h2>
                <div class="code-snippet">&lt;jsp:include page="..." /&gt;</div>
                
                <img src="images/dynamic-image.jpg" alt="Dynamic Example" class="image-preview">
                
                <ul class="feature-list">
                    <li>Request-time inclusion (runtime)</li>
                    <li>Independent execution of included resource</li>
                    <li>Supports dynamic parameters</li>
                    <li>Perfect for dynamic content</li>
                    <li>Can use expressions for page selection</li>
                </ul>
                
                <a href="dynamic-include.jsp" class="action-link">View Example →</a>
            </div>
        </div>
        
        <div class="comparison-section">
            <h2>Comparison</h2>
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>Aspect</th>
                        <th>Static Include</th>
                        <th>Dynamic Include</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Execution Time</td>
                        <td>Translation Time</td>
                        <td>Request Processing Time</td>
                    </tr>
                    <tr>
                        <td>Processing</td>
                        <td>Files merged before compilation</td>
                        <td>Separate execution, output combined</td>
                    </tr>
                    <tr>
                        <td>Performance</td>
                        <td>Faster (no runtime overhead)</td>
                        <td>Slight overhead</td>
                    </tr>
                    <tr>
                        <td>Flexibility</td>
                        <td>Static binding</td>
                        <td>Dynamic (supports expressions)</td>
                    </tr>
                    <tr>
                        <td>Parameters</td>
                        <td>Cannot pass parameters</td>
                        <td>Can pass via &lt;jsp:param&gt;</td>
                    </tr>
                    <tr>
                        <td>Use Case</td>
                        <td>Headers, footers, templates</td>
                        <td>Dynamic content, components</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="footer">
            <p>JSP Directive Educational Module</p>
        </div>
    </div>
</body>
</html>
