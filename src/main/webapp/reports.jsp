<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reports.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="reports"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128200; Reports</h1>
            <div class="header-actions">
                <button class="btn btn-primary no-print" onclick="window.print()">&#128424; Print Report</button>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-secondary">&#128682; Logout</a>
            </div>
        </div>

        <div class="content-area">
            <div class="filter-bar no-print">
                <span><strong>Report Type:</strong></span>
                <a href="${pageContext.request.contextPath}/reports?type=revenue&startDate=${startDate}&endDate=${endDate}"
                   class="btn btn-sm ${reportType == 'revenue' ? 'btn-primary' : 'btn-outline'}">&#128176; Revenue Report</a>
                <a href="${pageContext.request.contextPath}/reports?type=occupancy&startDate=${startDate}&endDate=${endDate}"
                   class="btn btn-sm ${reportType == 'occupancy' ? 'btn-primary' : 'btn-outline'}">&#128719; Occupancy Report</a>
            </div>
            <div class="card no-print">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/reports">
                        <input type="hidden" name="type" value="${reportType}">
                        <div class="filter-bar mb-0">
                            <div class="form-group mb-0">
                                <label>Start Date</label>
                                <input type="date" name="startDate" class="form-control" value="${startDate}">
                            </div>
                            <div class="form-group mb-0">
                                <label>End Date</label>
                                <input type="date" name="endDate" class="form-control" value="${endDate}">
                            </div>
                            <div class="form-group mb-0" style="align-self:flex-end;">
                                <button type="submit" class="btn btn-primary">&#128270; Filter</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <c:if test="${reportType == 'revenue'}">
                <div class="card">
                    <div class="card-header">
                        <h3>&#128176; Revenue Report</h3>
                        <span class="text-muted">${startDate} to ${endDate}</span>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty revenueReport}">
                            <div class="report-summary-grid">
                                <div class="report-stat">
                                    <div class="value">${revenueReport.totalBills}</div>
                                    <div class="label">Total Bills</div>
                                </div>
                                <div class="report-stat">
                                    <div class="value"><fmt:formatNumber value="${revenueReport.totalRoomRevenue}" type="currency" currencySymbol="$"/></div>
                                    <div class="label">Room Revenue</div>
                                </div>
                                <div class="report-stat">
                                    <div class="value"><fmt:formatNumber value="${revenueReport.totalFoodRevenue}" type="currency" currencySymbol="$"/></div>
                                    <div class="label">Food Revenue</div>
                                </div>
                                <div class="report-stat">
                                    <div class="value"><fmt:formatNumber value="${revenueReport.totalTax}" type="currency" currencySymbol="$"/></div>
                                    <div class="label">Total Tax</div>
                                </div>
                                <div class="report-stat">
                                    <div class="value text-danger"><fmt:formatNumber value="${revenueReport.totalDiscounts}" type="currency" currencySymbol="$"/></div>
                                    <div class="label">Total Discounts</div>
                                </div>
                                <div class="report-stat" style="background:var(--primary); color:white;">
                                    <div class="value" style="color:white;"><fmt:formatNumber value="${revenueReport.totalRevenue}" type="currency" currencySymbol="$"/></div>
                                    <div class="label" style="color:rgba(255,255,255,0.8);">Total Revenue</div>
                                </div>
                            </div>
                            <c:if test="${not empty revenueReport.dailyBreakdown}">
                                <h4 style="margin:20px 0 10px;">Daily Revenue Breakdown</h4>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr><th>Date</th><th>Reservations</th><th class="text-right">Revenue</th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="day" items="${revenueReport.dailyBreakdown}">
                                                <tr>
                                                    <td>${day.date}</td>
                                                    <td>${day.reservations}</td>
                                                    <td class="text-right"><fmt:formatNumber value="${day.revenue}" type="currency" currencySymbol="$"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </c:if>
            <c:if test="${reportType == 'occupancy'}">
                <div class="card">
                    <div class="card-header">
                        <h3>&#128719; Room Occupancy Report</h3>
                        <span class="text-muted">${startDate} to ${endDate}</span>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty occupancyReport}">
                            <c:if test="${not empty occupancyReport.byRoomType}">
                                <h4 style="margin-bottom:15px;">Occupancy by Room Type</h4>
                                <div class="report-summary-grid">
                                    <c:forEach var="type" items="${occupancyReport.byRoomType}">
                                        <div class="report-stat">
                                            <div class="value">${type.occupancyRate}%</div>
                                            <div class="label">${type.roomType}</div>
                                            <div class="text-muted" style="font-size:12px;">${type.occupiedRooms} / ${type.totalRooms} rooms</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <c:if test="${not empty occupancyReport.roomDetails}">
                                <h4 style="margin:20px 0 10px;">Room Details</h4>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Room</th>
                                                <th>Type</th>
                                                <th>Rate</th>
                                                <th>Status</th>
                                                <th>Guest</th>
                                                <th>Check-in</th>
                                                <th>Check-out</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="rm" items="${occupancyReport.roomDetails}">
                                                <tr>
                                                    <td><strong>${rm.roomNumber}</strong></td>
                                                    <td>${rm.roomType}</td>
                                                    <td><fmt:formatNumber value="${rm.ratePerNight}" type="currency" currencySymbol="$"/></td>
                                                    <td>
                                                        <c:set var="rmStatus" value="badge-available"/>
                                                        <c:if test="${rm.status == 'Occupied'}"><c:set var="rmStatus" value="badge-occupied"/></c:if>
                                                        <c:if test="${rm.status == 'Reserved'}"><c:set var="rmStatus" value="badge-reserved"/></c:if>
                                                        <c:if test="${rm.status == 'Maintenance'}"><c:set var="rmStatus" value="badge-maintenance"/></c:if>
                                                        <span class="badge ${rmStatus}">${rm.status}</span>
                                                    </td>
                                                    <td>${rm.guestName != null ? rm.guestName : '-'}</td>
                                                    <td>${rm.checkInDate != null ? rm.checkInDate : '-'}</td>
                                                    <td>${rm.checkOutDate != null ? rm.checkOutDate : '-'}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
</body>
</html>

