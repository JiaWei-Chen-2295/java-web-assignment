<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
    <script>
        async function callApi() {
            const res = await fetch('/01/api/hello');
            const data = await res.json();
            document.getElementById('result').innerText = data.message;
        }
    </script>
</head>
<body>
    <h1>Hello World</h1>
    <button onclick="callApi()">调用接口</button>
    <p id="result"></p>
</body>
</html>
