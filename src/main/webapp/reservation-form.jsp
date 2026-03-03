<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty reservation ? 'Edit' : 'New'} Reservation - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservations.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="reservations"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">${not empty reservation ? '&#9999; Edit Reservation' : '&#10133; New Reservation'}</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/reservations" class="btn btn-secondary">&#11013; Back to List</a>
            </div>
        </div>

        <div class="content-area">
            <div class="card">
                <div class="card-header">
                    <h3>${not empty reservation ? 'Edit Reservation: '.concat(reservation.reservationNumber) : 'Create New Reservation'}</h3>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/reservations">
                        <input type="hidden" name="action" value="${not empty reservation ? 'update' : 'add'}">
                        <c:if test="${not empty reservation}">
                            <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                            <input type="hidden" name="reservationNumber" value="${reservation.reservationNumber}">
                        </c:if>
                        <div class="form-group">
                            <label>Reservation Number</label>
                            <input type="text" class="form-control" value="${not empty reservation ? reservation.reservationNumber : reservationNumber}" readonly
                                   name="${empty reservation ? 'reservationNumber' : ''}">
                        </div>
                        <h4 style="margin:20px 0 15px; color:var(--primary);">&#128100; Guest Details</h4>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Guest Name *</label>
                                <input type="text" name="guestName" class="form-control" required
                                       value="${reservation.guestName}" placeholder="Full name of the guest">
                            </div>
                            <div class="form-group">
                                <label>Contact Number *</label>
                                <input type="text" name="contactNumber" class="form-control" required
                                       value="${reservation.contactNumber}" placeholder="Phone number">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="${reservation.email}" placeholder="Email address">
                            </div>
                            <div class="form-group">
                                <label>Number of Guests *</label>
                                <input type="number" name="numGuests" class="form-control" min="1" required
                                       value="${not empty reservation ? reservation.numGuests : 1}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Address *</label>
                            <textarea name="address" class="form-control" required placeholder="Guest address">${reservation.address}</textarea>
                        </div>
                        <h4 style="margin:20px 0 15px; color:var(--primary);">&#128719; Room & Dates</h4>
                        <div class="form-group">
                            <label>Select Room *</label>
                            <select name="roomId" class="form-control" required>
                                <option value="">-- Select a Room --</option>
                                <c:forEach var="room" items="${rooms}">
                                    <option value="${room.roomId}" ${reservation.roomId == room.roomId ? 'selected' : ''}>
                                        Room ${room.roomNumber} - ${room.roomType}
                                        ($<fmt:formatNumber value="${room.ratePerNight}" type="number" minFractionDigits="2"/>/night)
                                        [${room.status}]
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Check-in Date *</label>
                                <input type="date" name="checkInDate" class="form-control" required
                                       value="${reservation.checkInDate}">
                            </div>
                            <div class="form-group">
                                <label>Check-out Date *</label>
                                <input type="date" name="checkOutDate" class="form-control" required
                                       value="${reservation.checkOutDate}">
                            </div>
                        </div>

                        <c:if test="${not empty reservation}">
                            <div class="form-group">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="Confirmed" ${reservation.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                    <option value="Checked-In" ${reservation.status == 'Checked-In' ? 'selected' : ''}>Checked-In</option>
                                    <option value="Checked-Out" ${reservation.status == 'Checked-Out' ? 'selected' : ''}>Checked-Out</option>
                                    <option value="Cancelled" ${reservation.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label>Special Requests</label>
                            <textarea name="specialRequests" class="form-control"
                                      placeholder="Any special requirements...">${reservation.specialRequests}</textarea>
                        </div>

                        <div class="btn-group" style="margin-top:20px;">
                            <button type="submit" class="btn btn-primary btn-lg">
                                ${not empty reservation ? '&#128190; Update Reservation' : '&#10133; Create Reservation'}
                            </button>
                            <a href="${pageContext.request.contextPath}/reservations" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

