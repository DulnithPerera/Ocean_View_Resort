<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservations.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="reservations"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128221; Reservations</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">&#10133; New Reservation</a>
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
            <div class="filter-bar">
                <span><strong>Filter by Status:</strong></span>
                <a href="${pageContext.request.contextPath}/reservations" class="btn btn-sm ${empty currentFilter ? 'btn-primary' : 'btn-outline'}">All</a>
                <a href="${pageContext.request.contextPath}/reservations?status=Confirmed" class="btn btn-sm ${currentFilter == 'Confirmed' ? 'btn-primary' : 'btn-outline'}">Confirmed</a>
                <a href="${pageContext.request.contextPath}/reservations?status=Checked-In" class="btn btn-sm ${currentFilter == 'Checked-In' ? 'btn-primary' : 'btn-outline'}">Checked-In</a>
                <a href="${pageContext.request.contextPath}/reservations?status=Checked-Out" class="btn btn-sm ${currentFilter == 'Checked-Out' ? 'btn-primary' : 'btn-outline'}">Checked-Out</a>
                <a href="${pageContext.request.contextPath}/reservations?status=Cancelled" class="btn btn-sm ${currentFilter == 'Cancelled' ? 'btn-primary' : 'btn-outline'}">Cancelled</a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Reservation List</h3>
                    <span class="text-muted">${fn:length(reservations)} reservations</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty reservations}">
                            <div class="empty-state">
                                <div class="empty-icon">&#128221;</div>
                                <p>No reservations found.</p>
                                <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-primary">&#10133; Create First Reservation</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Res. No.</th>
                                            <th>Guest Name</th>
                                            <th>Room</th>
                                            <th>Check-in</th>
                                            <th>Check-out</th>
                                            <th>Status</th>
                                            <th>Contact</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="res" items="${reservations}">
                                            <tr>
                                                <td><strong>${res.reservationNumber}</strong></td>
                                                <td>${res.guestName}</td>
                                                <td>${res.roomNumber} (${res.roomType})</td>
                                                <td>${res.checkInDate}</td>
                                                <td>${res.checkOutDate}</td>
                                                <td>
                                                    <c:set var="sClass" value="badge-confirmed"/>
                                                    <c:if test="${res.status == 'Checked-In'}"><c:set var="sClass" value="badge-checked-in"/></c:if>
                                                    <c:if test="${res.status == 'Checked-Out'}"><c:set var="sClass" value="badge-checked-out"/></c:if>
                                                    <c:if test="${res.status == 'Cancelled'}"><c:set var="sClass" value="badge-cancelled"/></c:if>
                                                    <span class="badge ${sClass}">${res.status}</span>
                                                </td>
                                                <td>${res.contactNumber}</td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="${pageContext.request.contextPath}/reservations?action=view&id=${res.reservationId}" class="btn btn-sm btn-info">&#128065; View</a>
                                                        <c:if test="${res.status == 'Confirmed'}">
                                                            <a href="${pageContext.request.contextPath}/reservations?action=edit&id=${res.reservationId}" class="btn btn-sm btn-warning">&#9999; Edit</a>
                                                            <form method="post" action="${pageContext.request.contextPath}/reservations" style="display:inline">
                                                                <input type="hidden" name="action" value="checkin">
                                                                <input type="hidden" name="id" value="${res.reservationId}">
                                                                <button type="submit" class="btn btn-sm btn-success">&#10004; Check In</button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${res.status == 'Checked-In'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/reservations" style="display:inline">
                                                                <input type="hidden" name="action" value="checkout">
                                                                <input type="hidden" name="id" value="${res.reservationId}">
                                                                <button type="submit" class="btn btn-sm btn-warning">&#128682; Check Out</button>
                                                            </form>
                                                            <a href="${pageContext.request.contextPath}/food-orders?reservationId=${res.reservationId}" class="btn btn-sm btn-info">&#127869; Food</a>
                                                        </c:if>
                                                        <c:if test="${res.status == 'Confirmed' || res.status == 'Checked-In'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/reservations" style="display:inline">
                                                                <input type="hidden" name="action" value="cancel">
                                                                <input type="hidden" name="id" value="${res.reservationId}">
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Cancel this reservation?')">&#10060; Cancel</button>
                                                            </form>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/bills?action=generate&reservationId=${res.reservationId}" class="btn btn-sm btn-secondary">&#128176; Bill</a>
                                                        <form method="post" action="${pageContext.request.contextPath}/reservations" style="display:inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${res.reservationId}">
                                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Permanently delete this reservation?')">&#128465;</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

