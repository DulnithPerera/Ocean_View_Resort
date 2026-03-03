<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservations.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="reservations"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128065; Reservation Details</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/reservations" class="btn btn-secondary">&#11013; Back</a>
            </div>
        </div>

        <div class="content-area">
            <c:if test="${not empty reservation}">
                <div class="card">
                    <div class="card-header">
                        <h3>Reservation: ${reservation.reservationNumber}</h3>
                        <c:set var="sClass" value="badge-confirmed"/>
                        <c:if test="${reservation.status == 'Checked-In'}"><c:set var="sClass" value="badge-checked-in"/></c:if>
                        <c:if test="${reservation.status == 'Checked-Out'}"><c:set var="sClass" value="badge-checked-out"/></c:if>
                        <c:if test="${reservation.status == 'Cancelled'}"><c:set var="sClass" value="badge-cancelled"/></c:if>
                        <span class="badge ${sClass}">${reservation.status}</span>
                    </div>
                    <div class="card-body">
                        <div class="bill-details-grid">
                            <div>
                                <h4 style="color:var(--primary); margin-bottom:15px;">&#128100; Guest Information</h4>
                                <table class="table">
                                    <tr><td><strong>Guest Name</strong></td><td>${reservation.guestName}</td></tr>
                                    <tr><td><strong>Contact</strong></td><td>${reservation.contactNumber}</td></tr>
                                    <tr><td><strong>Email</strong></td><td>${reservation.email}</td></tr>
                                    <tr><td><strong>Address</strong></td><td>${reservation.address}</td></tr>
                                    <tr><td><strong>Guests</strong></td><td>${reservation.numGuests}</td></tr>
                                </table>
                            </div>
                            <div>
                                <h4 style="color:var(--primary); margin-bottom:15px;">&#128719; Booking Information</h4>
                                <table class="table">
                                    <tr><td><strong>Reservation No.</strong></td><td>${reservation.reservationNumber}</td></tr>
                                    <tr><td><strong>Room</strong></td><td>${reservation.roomNumber} (${reservation.roomType})</td></tr>
                                    <tr><td><strong>Rate/Night</strong></td><td><fmt:formatNumber value="${reservation.ratePerNight}" type="currency" currencySymbol="$"/></td></tr>
                                    <tr><td><strong>Check-in</strong></td><td>${reservation.checkInDate}</td></tr>
                                    <tr><td><strong>Check-out</strong></td><td>${reservation.checkOutDate}</td></tr>
                                    <tr><td><strong>Nights</strong></td><td>${reservation.nights}</td></tr>
                                    <tr><td><strong>Est. Room Cost</strong></td><td><fmt:formatNumber value="${reservation.ratePerNight * reservation.nights}" type="currency" currencySymbol="$"/></td></tr>
                                </table>
                            </div>
                        </div>
                        <c:if test="${not empty reservation.specialRequests}">
                            <div class="mt-20">
                                <h4 style="color:var(--primary); margin-bottom:10px;">&#128221; Special Requests</h4>
                                <p>${reservation.specialRequests}</p>
                            </div>
                        </c:if>
                        <div class="btn-group mt-20">
                            <a href="${pageContext.request.contextPath}/reservations?action=edit&id=${reservation.reservationId}" class="btn btn-warning">&#9999; Edit</a>
                            <a href="${pageContext.request.contextPath}/food-orders?reservationId=${reservation.reservationId}" class="btn btn-info">&#127869; Food Orders</a>
                            <a href="${pageContext.request.contextPath}/bills?action=generate&reservationId=${reservation.reservationId}" class="btn btn-success">&#128176; Generate Bill</a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

