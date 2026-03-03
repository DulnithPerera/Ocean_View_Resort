<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rooms.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="rooms"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128719; Room Management</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="openModal('addRoomModal')">&#10133; Add Room</button>
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
                    <h3>All Rooms</h3>
                    <span class="text-muted">${fn:length(rooms)} rooms</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Room No.</th>
                                    <th>Type</th>
                                    <th>Floor</th>
                                    <th>Rate/Night</th>
                                    <th>Max Guests</th>
                                    <th>Status</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${rooms}">
                                    <tr>
                                        <td><strong>${room.roomNumber}</strong></td>
                                        <td>${room.roomType}</td>
                                        <td>Floor ${room.floor}</td>
                                        <td><fmt:formatNumber value="${room.ratePerNight}" type="currency" currencySymbol="$"/></td>
                                        <td>${room.maxGuests}</td>
                                        <td>
                                            <c:set var="statusClass" value="badge-available"/>
                                            <c:if test="${room.status == 'Occupied'}"><c:set var="statusClass" value="badge-occupied"/></c:if>
                                            <c:if test="${room.status == 'Reserved'}"><c:set var="statusClass" value="badge-reserved"/></c:if>
                                            <c:if test="${room.status == 'Maintenance'}"><c:set var="statusClass" value="badge-maintenance"/></c:if>
                                            <span class="badge ${statusClass}">${room.status}</span>
                                        </td>
                                        <td style="max-width:200px;">${room.description}</td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-info"
                                                    onclick="editRoom(${room.roomId}, '${room.roomNumber}', '${room.roomType}', ${room.ratePerNight}, '${room.status}', ${room.floor}, '${room.description}', ${room.maxGuests})">
                                                    &#9999; Edit
                                                </button>
                                                <form method="post" action="${pageContext.request.contextPath}/rooms" style="display:inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${room.roomId}">
                                                    <button type="submit" class="btn btn-sm btn-danger"
                                                        onclick="return confirm('Delete room ${room.roomNumber}?')">
                                                        &#128465; Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
<div class="modal-overlay" id="addRoomModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#10133; Add New Room</h3>
            <button class="modal-close" onclick="closeModal('addRoomModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/rooms">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Room Number</label>
                        <input type="text" name="roomNumber" class="form-control" required placeholder="e.g., 101">
                    </div>
                    <div class="form-group">
                        <label>Room Type</label>
                        <select name="roomType" class="form-control" required>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Suite">Suite</option>
                            <option value="Ocean View Suite">Ocean View Suite</option>
                            <option value="Presidential Suite">Presidential Suite</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Rate Per Night ($)</label>
                        <input type="number" name="ratePerNight" class="form-control" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label>Floor</label>
                        <input type="number" name="floor" class="form-control" min="1" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Max Guests</label>
                    <input type="number" name="maxGuests" class="form-control" min="1" value="2" required>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" class="form-control" placeholder="Room description..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addRoomModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#10133; Add Room</button>
            </div>
        </form>
    </div>
</div>
<div class="modal-overlay" id="editRoomModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#9999; Edit Room</h3>
            <button class="modal-close" onclick="closeModal('editRoomModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/rooms">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="roomId" id="editRoomId">
            <div class="modal-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Room Number</label>
                        <input type="text" name="roomNumber" id="editRoomNumber" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Room Type</label>
                        <select name="roomType" id="editRoomType" class="form-control" required>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Suite">Suite</option>
                            <option value="Ocean View Suite">Ocean View Suite</option>
                            <option value="Presidential Suite">Presidential Suite</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Rate Per Night ($)</label>
                        <input type="number" name="ratePerNight" id="editRatePerNight" class="form-control" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" id="editRoomStatus" class="form-control" required>
                            <option value="Available">Available</option>
                            <option value="Occupied">Occupied</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Floor</label>
                        <input type="number" name="floor" id="editFloor" class="form-control" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Max Guests</label>
                        <input type="number" name="maxGuests" id="editMaxGuests" class="form-control" min="1" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="editDescription" class="form-control"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editRoomModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#128190; Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

function editRoom(id, number, type, rate, status, floor, desc, maxGuests) {
    document.getElementById('editRoomId').value = id;
    document.getElementById('editRoomNumber').value = number;
    document.getElementById('editRoomType').value = type;
    document.getElementById('editRatePerNight').value = rate;
    document.getElementById('editRoomStatus').value = status;
    document.getElementById('editFloor').value = floor;
    document.getElementById('editDescription').value = desc;
    document.getElementById('editMaxGuests').value = maxGuests;
    openModal('editRoomModal');
}
</script>
</body>
</html>

