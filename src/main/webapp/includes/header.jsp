<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="sidebar">
    <div class="sidebar-header">
        <span class="logo-icon">&#127754;</span>
        <h2>Ocean View Resort</h2>
        <p>Galle, Sri Lanka</p>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Main</div>
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item ${param.active == 'dashboard' ? 'active' : ''}">
            <span class="nav-icon">&#127968;</span> Dashboard
        </a>

        <div class="nav-section">Management</div>
        <a href="${pageContext.request.contextPath}/reservations" class="nav-item ${param.active == 'reservations' ? 'active' : ''}">
            <span class="nav-icon">&#128221;</span> Reservations
        </a>
        <a href="${pageContext.request.contextPath}/rooms" class="nav-item ${param.active == 'rooms' ? 'active' : ''}">
            <span class="nav-icon">&#128719;</span> Rooms
        </a>
        <a href="${pageContext.request.contextPath}/food-orders" class="nav-item ${param.active == 'food' ? 'active' : ''}">
            <span class="nav-icon">&#127869;</span> Food Orders
        </a>
        <a href="${pageContext.request.contextPath}/foods" class="nav-item ${param.active == 'foods' ? 'active' : ''}">
            <span class="nav-icon">&#127828;</span> Food Menu
        </a>
        <a href="${pageContext.request.contextPath}/bills" class="nav-item ${param.active == 'bills' ? 'active' : ''}">
            <span class="nav-icon">&#128176;</span> Bills
        </a>

        <div class="nav-section">Analytics</div>
        <a href="${pageContext.request.contextPath}/reports?type=revenue" class="nav-item ${param.active == 'reports' ? 'active' : ''}">
            <span class="nav-icon">&#128200;</span> Reports
        </a>

        <c:if test="${sessionScope.role == 'admin'}">
            <div class="nav-section">Administration</div>
            <a href="${pageContext.request.contextPath}/users" class="nav-item ${param.active == 'users' ? 'active' : ''}">
                <span class="nav-icon">&#128101;</span> User Management
            </a>
        </c:if>

        <div class="nav-section">Support</div>
        <a href="${pageContext.request.contextPath}/help" class="nav-item ${param.active == 'help' ? 'active' : ''}">
            <span class="nav-icon">&#10067;</span> Help & Guide
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-info">
            <div class="user-avatar">
                ${fn:substring(sessionScope.fullName, 0, 1)}
            </div>
            <div class="user-details">
                <div class="user-name">${sessionScope.fullName}</div>
                <div class="user-role">${sessionScope.role}</div>
            </div>
        </div>
    </div>
</div>

