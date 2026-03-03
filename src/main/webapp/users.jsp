<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/users.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="users"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#128101; User Management</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="openModal('addUserModal')">&#10133; Add New User</button>
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
                    <h3>All Users</h3>
                    <span class="text-muted">${fn:length(users)} users</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Created</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>${u.userId}</td>
                                        <td><strong>${u.username}</strong></td>
                                        <td>${u.fullName}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <span class="badge badge-${u.role}">${u.role}</span>
                                        </td>
                                        <td>
                                            <span class="badge ${u.active ? 'badge-active' : 'badge-inactive'}">
                                                ${u.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>${u.createdAt}</td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-info"
                                                    onclick="editUser(${u.userId}, '${u.username}', '${u.fullName}', '${u.email}', '${u.role}', ${u.active})">
                                                    &#9999; Edit
                                                </button>
                                                <button class="btn btn-sm btn-warning"
                                                    onclick="resetPassword(${u.userId}, '${u.username}')">
                                                    &#128273; Reset Password
                                                </button>
                                                <c:if test="${u.userId != sessionScope.userId}">
                                                    <form method="post" action="${pageContext.request.contextPath}/users" style="display:inline">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${u.userId}">
                                                        <button type="submit" class="btn btn-sm btn-danger"
                                                            onclick="return confirm('Deactivate user ${u.username}?')">
                                                            &#128683; Deactivate
                                                        </button>
                                                    </form>
                                                </c:if>
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
<div class="modal-overlay" id="addUserModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#10133; Add New User</h3>
            <button class="modal-close" onclick="closeModal('addUserModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/users">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="role" class="form-control" required>
                        <option value="staff">Staff</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addUserModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#10133; Add User</button>
            </div>
        </form>
    </div>
</div>
<div class="modal-overlay" id="editUserModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#9999; Edit User</h3>
            <button class="modal-close" onclick="closeModal('editUserModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/users">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" id="editUserId">
            <div class="modal-body">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" id="editUsername" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" id="editFullName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="editEmail" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="role" id="editRole" class="form-control" required>
                        <option value="staff">Staff</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" name="isActive" id="editIsActive">
                        <label for="editIsActive">Active</label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editUserModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">&#128190; Save Changes</button>
            </div>
        </form>
    </div>
</div>
<div class="modal-overlay" id="resetPasswordModal">
    <div class="modal">
        <div class="modal-header">
            <h3>&#128273; Reset Password</h3>
            <button class="modal-close" onclick="closeModal('resetPasswordModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/users">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="userId" id="resetUserId">
            <div class="modal-body">
                <p class="mb-20">Reset password for user: <strong id="resetUsername"></strong></p>
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" name="newPassword" class="form-control" required minlength="4">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('resetPasswordModal')">Cancel</button>
                <button type="submit" class="btn btn-warning">&#128273; Reset Password</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

function editUser(id, username, fullName, email, role, isActive) {
    document.getElementById('editUserId').value = id;
    document.getElementById('editUsername').value = username;
    document.getElementById('editFullName').value = fullName;
    document.getElementById('editEmail').value = email;
    document.getElementById('editRole').value = role;
    document.getElementById('editIsActive').checked = isActive;
    openModal('editUserModal');
}

function resetPassword(id, username) {
    document.getElementById('resetUserId').value = id;
    document.getElementById('resetUsername').textContent = username;
    openModal('resetPasswordModal');
}
</script>
</body>
</html>

