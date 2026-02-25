<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
</head>
<body>
<div class="login-page">
    <div class="login-container" style="text-align:center;">
        <span style="font-size:64px;">&#9888;</span>
        <h1 style="color:var(--danger); margin:15px 0;">Oops! Something went wrong</h1>
        <p style="color:var(--gray-500); margin-bottom:20px;">
            The page you are looking for could not be found or an error occurred.
        </p>
        <% if (request.getAttribute("javax.servlet.error.status_code") != null) { %>
            <p style="margin-bottom:10px;">
                <strong>Error Code:</strong> <%= request.getAttribute("javax.servlet.error.status_code") %>
            </p>
        <% } %>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">&#127968; Go to Dashboard</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-lg">&#128274; Go to Login</a>
    </div>
</div>
</body>
</html>

