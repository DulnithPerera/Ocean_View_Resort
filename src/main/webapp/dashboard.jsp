<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="dashboard"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#127968; Dashboard</h1>
            <div class="header-actions">
                <span>Welcome, <strong>${sessionScope.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-secondary">&#128682; Logout</a>
            </div>
        </div>

        <div class="content-area">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success">&#9989; ${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">&#9888; ${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-icon">&#128719;</div>
                    <div class="stat-info">
                        <h4>${totalRooms}</h4>
                        <p>Total Rooms</p>
                    </div>
                </div>
                <div class="stat-card success">
                    <div class="stat-icon">&#9989;</div>
                    <div class="stat-info">
                        <h4>${availableRooms}</h4>
                        <p>Available Rooms</p>
                    </div>
                </div>
                <div class="stat-card danger">
                    <div class="stat-icon">&#128276;</div>
                    <div class="stat-info">
                        <h4>${occupiedRooms}</h4>
                        <p>Occupied / Reserved</p>
                    </div>
                </div>
                <div class="stat-card warning">
                    <div class="stat-icon">&#128221;</div>
                    <div class="stat-info">
                        <h4>${activeReservations}</h4>
                        <p>Active Reservations</p>
                    </div>
                </div>
                <div class="stat-card info">
                    <div class="stat-icon">&#128205;</div>
                    <div class="stat-info">
                        <h4>${todayCheckIns}</h4>
                        <p>Today's Check-ins</p>
                    </div>
                </div>
                <div class="stat-card accent">
                    <div class="stat-icon">&#128176;</div>
                    <div class="stat-info">
                        <h4><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="$"/></h4>
                        <p>Today's Revenue</p>
                    </div>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#9889; Quick Actions</h3>
                </div>
                <div class="card-body">
                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">
                            &#10133; New Reservation
                        </a>
                        <a href="${pageContext.request.contextPath}/reservations" class="btn btn-info">
                            &#128221; View Reservations
                        </a>
                        <a href="${pageContext.request.contextPath}/rooms" class="btn btn-success">
                            &#128719; Manage Rooms
                        </a>
                        <a href="${pageContext.request.contextPath}/food-orders" class="btn btn-warning">
                            &#127869; Food Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/bills" class="btn btn-secondary">
                            &#128176; Bills
                        </a>
                        <a href="${pageContext.request.contextPath}/reports?type=revenue" class="btn btn-outline">
                            &#128200; Revenue Report
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/includes/footer.jsp"/>
    </div>

</div>
</body>
</html>

