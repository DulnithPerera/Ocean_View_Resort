<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Menu - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/foods.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="foods"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#127828; Food Menu Management</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="openModal('addFoodModal')">&#10133; Add Food Item</button>
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
                    <h3>Food Menu Items</h3>
                    <span class="text-muted">${fn:length(foods)} items</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty foods}">
                            <div class="empty-state">
                                <div class="empty-icon">&#127828;</div>
                                <p>No food items in the menu yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Food Name</th>
                                            <th>Type</th>
                                            <th>Price</th>
                                            <th>Description</th>
                                            <th>Available</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="food" items="${foods}">
                                            <tr>
                                                <td>${food.foodId}</td>
                                                <td><strong>${food.foodName}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${food.foodType == 'Breakfast'}">&#127748;</c:when>
                                                        <c:when test="${food.foodType == 'Lunch'}">&#9728;</c:when>
                                                        <c:when test="${food.foodType == 'Dinner'}">&#127769;</c:when>
                                                    </c:choose>
                                                    ${food.foodType}
                                                </td>
                                                <td><fmt:formatNumber value="${food.price}" type="currency" currencySymbol="$"/></td>
                                                <td style="max-width:200px;">${food.description}</td>
                                                <td>
                                                    <span class="badge ${food.available ? 'badge-active' : 'badge-inactive'}">
                                                        ${food.available ? 'Yes' : 'No'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button class="btn btn-sm btn-info"
                                                            onclick="editFood(${food.foodId}, '${food.foodName}', '${food.foodType}', ${food.price}, '${food.description}', ${food.available})">
                                                            &#9999; Edit
                                                        </button>
                                                        <form method="post" action="${pageContext.request.contextPath}/foods" style="display:inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${food.foodId}">
                                                            <button type="submit" class="btn btn-sm btn-danger"
                                                                onclick="return confirm('Delete food item: ${food.foodName}?')">
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
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>
<div class="modal-overlay" id="addFoodModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#10133; Add Food Item</h3>
            <button class="modal-close" onclick="closeModal('addFoodModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/foods">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label>Food Name</label>
                    <input type="text" name="foodName" class="form-control" required placeholder="e.g., Grilled Salmon">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Food Type</label>
                        <select name="foodType" class="form-control" required>
                            <option value="Breakfast">&#127748; Breakfast</option>
                            <option value="Lunch">&#9728; Lunch</option>
                            <option value="Dinner">&#127769; Dinner</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Price ($)</label>
                        <input type="number" name="price" class="form-control" step="0.01" min="0" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" class="form-control" placeholder="Describe the food item..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addFoodModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#10133; Add Food Item</button>
            </div>
        </form>
    </div>
</div>
<div class="modal-overlay" id="editFoodModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#9999; Edit Food Item</h3>
            <button class="modal-close" onclick="closeModal('editFoodModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/foods">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="foodId" id="editFoodId">
            <div class="modal-body">
                <div class="form-group">
                    <label>Food Name</label>
                    <input type="text" name="foodName" id="editFoodName" class="form-control" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Food Type</label>
                        <select name="foodType" id="editFoodType" class="form-control" required>
                            <option value="Breakfast">&#127748; Breakfast</option>
                            <option value="Lunch">&#9728; Lunch</option>
                            <option value="Dinner">&#127769; Dinner</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Price ($)</label>
                        <input type="number" name="price" id="editFoodPrice" class="form-control" step="0.01" min="0" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="editFoodDesc" class="form-control"></textarea>
                </div>
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" name="isAvailable" id="editFoodAvailable">
                        <label for="editFoodAvailable">Available</label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editFoodModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#128190; Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

function editFood(id, name, type, price, desc, available) {
    document.getElementById('editFoodId').value = id;
    document.getElementById('editFoodName').value = name;
    document.getElementById('editFoodType').value = type;
    document.getElementById('editFoodPrice').value = price;
    document.getElementById('editFoodDesc').value = desc;
    document.getElementById('editFoodAvailable').checked = available;
    openModal('editFoodModal');
}
</script>
</body>
</html>

