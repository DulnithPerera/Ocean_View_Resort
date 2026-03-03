<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Orders - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/food-orders.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="food"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#127869; Food Orders</h1>
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
                    <h3>&#128221; Select Reservation</h3>
                </div>
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/food-orders">
                        <div class="form-row">
                            <div class="form-group mb-0">
                                <select name="reservationId" class="form-control" required onchange="this.form.submit()">
                                    <option value="">-- Select a Reservation --</option>
                                    <optgroup label="Checked-In Guests">
                                        <c:forEach var="res" items="${activeReservations}">
                                            <option value="${res.reservationId}" ${reservation.reservationId == res.reservationId ? 'selected' : ''}>
                                                ${res.reservationNumber} - ${res.guestName} (Room ${res.roomNumber})
                                            </option>
                                        </c:forEach>
                                    </optgroup>
                                    <optgroup label="Confirmed Reservations">
                                        <c:forEach var="res" items="${confirmedReservations}">
                                            <option value="${res.reservationId}" ${reservation.reservationId == res.reservationId ? 'selected' : ''}>
                                                ${res.reservationNumber} - ${res.guestName} (Room ${res.roomNumber})
                                            </option>
                                        </c:forEach>
                                    </optgroup>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty reservation}">
                <div class="card">
                    <div class="card-header">
                        <h3>&#10133; Add Food Order for ${reservation.guestName}</h3>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/food-orders">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Select Food Item</label>
                                    <select name="foodId" class="form-control" required>
                                        <option value="">-- Select Food --</option>
                                        <optgroup label="&#127748; Breakfast">
                                            <c:forEach var="f" items="${breakfastFoods}">
                                                <option value="${f.foodId}">${f.foodName} - $<fmt:formatNumber value="${f.price}" type="number" minFractionDigits="2"/></option>
                                            </c:forEach>
                                        </optgroup>
                                        <optgroup label="&#9728; Lunch">
                                            <c:forEach var="f" items="${lunchFoods}">
                                                <option value="${f.foodId}">${f.foodName} - $<fmt:formatNumber value="${f.price}" type="number" minFractionDigits="2"/></option>
                                            </c:forEach>
                                        </optgroup>
                                        <optgroup label="&#127769; Dinner">
                                            <c:forEach var="f" items="${dinnerFoods}">
                                                <option value="${f.foodId}">${f.foodName} - $<fmt:formatNumber value="${f.price}" type="number" minFractionDigits="2"/></option>
                                            </c:forEach>
                                        </optgroup>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Quantity</label>
                                    <input type="number" name="quantity" class="form-control" min="1" value="1" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">&#10133; Add Order</button>
                        </form>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3>&#128196; Current Food Orders</h3>
                        <span class="text-bold text-primary">
                            Total: <fmt:formatNumber value="${totalFoodCharges}" type="currency" currencySymbol="$"/>
                        </span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty foodOrders}">
                                <div class="empty-state">
                                    <p>No food orders yet for this reservation.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Food Item</th>
                                                <th>Type</th>
                                                <th>Unit Price</th>
                                                <th>Qty</th>
                                                <th>Total</th>
                                                <th>Date</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${foodOrders}">
                                                <tr>
                                                    <td><strong>${order.foodName}</strong></td>
                                                    <td>${order.foodType}</td>
                                                    <td><fmt:formatNumber value="${order.unitPrice}" type="currency" currencySymbol="$"/></td>
                                                    <td>${order.quantity}</td>
                                                    <td><strong><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$"/></strong></td>
                                                    <td>${order.orderDate}</td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/food-orders" style="display:inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${order.id}">
                                                            <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Remove this food order?')">&#128465; Remove</button>
                                                        </form>
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
            </c:if>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

