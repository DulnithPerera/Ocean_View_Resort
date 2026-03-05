<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bills.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="bills"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128176; Generate Bill</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/bills" class="btn btn-secondary">&#11013; Back to Bills</a>
            </div>
        </div>

        <div class="content-area">
            <c:if test="${not empty reservation}">
                <div class="card">
                    <div class="card-header">
                        <h3>Bill for: ${reservation.reservationNumber} - ${reservation.guestName}</h3>
                    </div>
                    <div class="card-body">
                        <div class="bill-details-grid">
                            <div>
                                <h4 style="color:var(--primary); margin-bottom:10px;">Booking Details</h4>
                                <p><strong>Room:</strong> ${reservation.roomNumber} (${reservation.roomType})</p>
                                <p><strong>Check-in:</strong> ${reservation.checkInDate}</p>
                                <p><strong>Check-out:</strong> ${reservation.checkOutDate}</p>
                                <p><strong>Nights:</strong> ${reservation.nights}</p>
                                <p><strong>Rate/Night:</strong> <fmt:formatNumber value="${reservation.ratePerNight}" type="currency" currencySymbol="$"/></p>
                            </div>
                            <div>
                                <h4 style="color:var(--primary); margin-bottom:10px;">Food Orders</h4>
                                <c:choose>
                                    <c:when test="${not empty foodOrders}">
                                        <c:forEach var="order" items="${foodOrders}">
                                            <p>${order.foodName} x${order.quantity} = <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></p>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No food orders</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <hr style="margin:20px 0;">
                        <form method="post" action="${pageContext.request.contextPath}/bills">
                            <input type="hidden" name="action" value="generate">
                            <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                            <div class="form-group">
                                <label>Select Billing Type (Strategy Pattern)</label>
                                <select name="billingType" class="form-control" style="max-width:400px;">
                                    <option value="Standard">Standard - 10% Tax</option>
                                    <option value="Premium">Premium - 5% Service Charge + 10% Tax</option>
                                    <option value="Discount">Discount - 10% Discount + 10% Tax</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success btn-lg">&#128176; Generate Bill</button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

