<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bills - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bills.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="bills"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128176; Bills</h1>
            <div class="header-actions">
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

            <div class="card">
                <div class="card-header">
                    <h3>All Generated Bills</h3>
                    <span class="text-muted">${fn:length(bills)} bills</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty bills}">
                            <div class="empty-state">
                                <div class="empty-icon">&#128176;</div>
                                <p>No bills generated yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Bill ID</th>
                                            <th>Reservation</th>
                                            <th>Guest</th>
                                            <th>Room</th>
                                            <th>Room Charges</th>
                                            <th>Food Charges</th>
                                            <th>Total</th>
                                            <th>Type</th>
                                            <th>Date</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="bill" items="${bills}">
                                            <tr>
                                                <td>#${bill.billId}</td>
                                                <td><strong>${bill.reservationNumber}</strong></td>
                                                <td>${bill.guestName}</td>
                                                <td>${bill.roomNumber}</td>
                                                <td><fmt:formatNumber value="${bill.roomCharges}" type="currency" currencySymbol="$"/></td>
                                                <td><fmt:formatNumber value="${bill.foodCharges}" type="currency" currencySymbol="$"/></td>
                                                <td><strong><fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="$"/></strong></td>
                                                <td><span class="badge badge-confirmed">${bill.billingType}</span></td>
                                                <td>${bill.createdAt}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/bills?action=view&reservationId=${bill.reservationId}" class="btn btn-sm btn-info">&#128065; View</a>
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

