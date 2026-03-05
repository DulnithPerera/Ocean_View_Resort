<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bills.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="bills"/></jsp:include>

    <div class="main-content">
        <div class="top-header no-print">
            <h1 class="page-title">&#128176; Bill Details</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="window.print()">&#128424; Print Bill</button>
                <a href="${pageContext.request.contextPath}/bills" class="btn btn-secondary">&#11013; Back</a>
            </div>
        </div>

        <div class="content-area">
            <c:if test="${not empty bill}">
                <div class="bill-container">
                    <div class="card">
                        <div class="card-body">
                            <div class="bill-header-section">
                                <span style="font-size:48px;">&#127754;</span>
                                <h1>Ocean View Resort</h1>
                                <p>Galle, Sri Lanka | Tel: +94 91 234 5678</p>
                                <p>Email: info@oceanviewresort.com</p>
                                <hr style="margin:15px 0;">
                                <h2>INVOICE</h2>
                                <p>Bill #${bill.billId} | Date: <fmt:formatDate value="${bill.createdAt}" pattern="yyyy-MM-dd HH:mm"/></p>
                            </div>
                            <div class="bill-details-grid">
                                <div>
                                    <h4>Guest Details</h4>
                                    <p><strong>Name:</strong> ${reservation.guestName}</p>
                                    <p><strong>Contact:</strong> ${reservation.contactNumber}</p>
                                    <p><strong>Address:</strong> ${reservation.address}</p>
                                </div>
                                <div>
                                    <h4>Booking Details</h4>
                                    <p><strong>Reservation:</strong> ${reservation.reservationNumber}</p>
                                    <p><strong>Room:</strong> ${reservation.roomNumber} (${reservation.roomType})</p>
                                    <p><strong>Check-in:</strong> ${reservation.checkInDate}</p>
                                    <p><strong>Check-out:</strong> ${reservation.checkOutDate}</p>
                                    <p><strong>Nights:</strong> ${reservation.nights}</p>
                                </div>
                            </div>
                            <c:if test="${not empty foodOrders}">
                                <h4 style="margin-top:20px;">Food Orders</h4>
                                <table class="table">
                                    <thead>
                                        <tr><th>Item</th><th>Type</th><th>Qty</th><th class="text-right">Amount</th></tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${foodOrders}">
                                            <tr>
                                                <td>${order.foodName}</td>
                                                <td>${order.foodType}</td>
                                                <td>${order.quantity}</td>
                                                <td class="text-right"><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:if>
                            <div class="bill-summary">
                                <div class="bill-row">
                                    <span>Room Charges (${reservation.nights} nights x <fmt:formatNumber value="${reservation.ratePerNight}" type="currency" currencySymbol="$"/>)</span>
                                    <span><fmt:formatNumber value="${bill.roomCharges}" type="currency" currencySymbol="$"/></span>
                                </div>
                                <div class="bill-row">
                                    <span>Food Charges</span>
                                    <span><fmt:formatNumber value="${bill.foodCharges}" type="currency" currencySymbol="$"/></span>
                                </div>
                                <div class="bill-row" style="border-top:1px solid #ddd; padding-top:8px;">
                                    <span><strong>Subtotal</strong></span>
                                    <span><strong><fmt:formatNumber value="${bill.subtotal}" type="currency" currencySymbol="$"/></strong></span>
                                </div>
                                <c:if test="${bill.serviceCharge > 0}">
                                    <div class="bill-row">
                                        <span>Service Charge (5%)</span>
                                        <span><fmt:formatNumber value="${bill.serviceCharge}" type="currency" currencySymbol="$"/></span>
                                    </div>
                                </c:if>
                                <c:if test="${bill.discount > 0}">
                                    <div class="bill-row text-success">
                                        <span>Discount (10%)</span>
                                        <span>- <fmt:formatNumber value="${bill.discount}" type="currency" currencySymbol="$"/></span>
                                    </div>
                                </c:if>
                                <div class="bill-row">
                                    <span>Tax (10%)</span>
                                    <span><fmt:formatNumber value="${bill.tax}" type="currency" currencySymbol="$"/></span>
                                </div>
                                <div class="bill-row bill-total">
                                    <span>TOTAL AMOUNT</span>
                                    <span><fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="$"/></span>
                                </div>
                                <div class="bill-row">
                                    <span class="text-muted">Billing Type: ${bill.billingType}</span>
                                    <span></span>
                                </div>
                            </div>

                            <div style="text-align:center; margin-top:30px; color:var(--gray-500); font-size:13px;">
                                <p>Thank you for choosing Ocean View Resort!</p>
                                <p>We hope you had a wonderful stay. &#127754;</p>
                            </div>
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

