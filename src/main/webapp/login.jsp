<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
<div class="login-page">
    <div class="login-container">
        <div class="login-header">
            <span class="logo-icon">&#127754;</span>
            <h1>Ocean View Resort</h1>
            <p>Reservation Management System</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">&#9888; ${error}</div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="alert alert-success">&#9989; You have been logged out successfully.</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control"
                       placeholder="Enter your username"
                       value="${not empty rememberedUser ? rememberedUser : username}" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Enter your password" required>
            </div>
            <div class="form-group">
                <div class="form-check">
                    <input type="checkbox" id="rememberMe" name="rememberMe"
                           ${not empty rememberedUser ? 'checked' : ''}>
                    <label for="rememberMe">Remember me</label>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                &#128274; Sign In
            </button>
        </form>


    </div>
</div>
</body>
</html>

