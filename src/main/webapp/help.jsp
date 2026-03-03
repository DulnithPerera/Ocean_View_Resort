<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Guide - Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/help.css">
</head>
<body>
<div class="app-container">
    <jsp:include page="/includes/header.jsp"><jsp:param name="active" value="help"/></jsp:include>

    <div class="main-content">
        <div class="top-header">
            <h1 class="page-title">&#10067; Help & User Guide</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-secondary">&#128682; Logout</a>
            </div>
        </div>

        <div class="content-area">
            <div class="card">
                <div class="card-header">
                    <h3>&#128214; Ocean View Resort - Staff Guide</h3>
                </div>
                <div class="card-body">
                    <p style="margin-bottom:20px; color:var(--gray-500);">
                        Welcome to the Ocean View Resort Management System! This guide will help you navigate and use all system features.
                    </p>
                    <div class="accordion-item active">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128274; 1. Login & Authentication</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <ol>
                                    <li>Navigate to the login page at the system URL.</li>
                                    <li>Enter your <strong>username</strong> and <strong>password</strong>.</li>
                                    <li>Check <strong>"Remember me"</strong> if you want your username saved for next login.</li>
                                    <li>Click <strong>"Sign In"</strong> to access the system.</li>
                                    <li>Your session will expire after 30 minutes of inactivity.</li>
                                    <li>Always click <strong>"Logout"</strong> when done to secure your session.</li>
                                </ol>
                                <p><strong>Default credentials:</strong></p>
                                <ul>
                                    <li>Admin: username = <code>admin</code>, password = <code>admin123</code></li>
                                    <li>Staff: username = <code>staff1</code>, password = <code>12345</code></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#127968; 2. Dashboard Overview</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <p>The dashboard provides a quick summary of the hotel's current status:</p>
                                <ul>
                                    <li><strong>Total Rooms</strong> - Number of rooms in the hotel</li>
                                    <li><strong>Available Rooms</strong> - Rooms ready for booking</li>
                                    <li><strong>Occupied/Reserved</strong> - Rooms currently in use</li>
                                    <li><strong>Active Reservations</strong> - Confirmed and checked-in bookings</li>
                                    <li><strong>Today's Check-ins</strong> - Expected arrivals today</li>
                                    <li><strong>Today's Revenue</strong> - Revenue generated today</li>
                                </ul>
                                <p>Use the <strong>Quick Actions</strong> buttons to navigate directly to common tasks.</p>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128221; 3. Managing Reservations</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <h5>Creating a New Reservation:</h5>
                                <ol>
                                    <li>Click <strong>"New Reservation"</strong> from the reservations page.</li>
                                    <li>A unique reservation number is auto-generated.</li>
                                    <li>Enter guest details: name, contact, email, address.</li>
                                    <li>Select a room from the dropdown (shows availability and rates).</li>
                                    <li>Set check-in and check-out dates.</li>
                                    <li>Add any special requests.</li>
                                    <li>Click <strong>"Create Reservation"</strong>.</li>
                                </ol>
                                <h5>Reservation Actions:</h5>
                                <ul>
                                    <li><strong>View</strong> - See complete reservation details</li>
                                    <li><strong>Edit</strong> - Modify reservation information</li>
                                    <li><strong>Check In</strong> - Mark guest as arrived (changes room status to Occupied)</li>
                                    <li><strong>Check Out</strong> - Mark guest departure (room becomes Available)</li>
                                    <li><strong>Cancel</strong> - Cancel a reservation (room becomes Available)</li>
                                    <li><strong>Delete</strong> - Permanently remove a reservation</li>
                                </ul>
                                <h5>Filtering:</h5>
                                <p>Use the status filter buttons to view reservations by status (All, Confirmed, Checked-In, Checked-Out, Cancelled).</p>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128719; 4. Room Management</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <p>Manage all hotel rooms from the Rooms page:</p>
                                <ul>
                                    <li><strong>Add Room</strong> - Create a new room with number, type, rate, floor, and description.</li>
                                    <li><strong>Edit Room</strong> - Modify room details and status.</li>
                                    <li><strong>Delete Room</strong> - Remove a room (only if no active reservations).</li>
                                </ul>
                                <h5>Room Types & Rates:</h5>
                                <ul>
                                    <li>Standard - Basic comfortable room</li>
                                    <li>Deluxe - Spacious room with extra amenities</li>
                                    <li>Suite - Luxury suite with separate living area</li>
                                    <li>Ocean View Suite - Premium suite with ocean view</li>
                                    <li>Presidential Suite - Top-tier luxury accommodation</li>
                                </ul>
                                <h5>Room Status:</h5>
                                <ul>
                                    <li><strong>Available</strong> - Ready for booking</li>
                                    <li><strong>Reserved</strong> - Booked but guest not arrived</li>
                                    <li><strong>Occupied</strong> - Guest currently staying</li>
                                    <li><strong>Maintenance</strong> - Under maintenance/cleaning</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#127869; 5. Food Orders</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <ol>
                                    <li>Go to <strong>Food Orders</strong> page.</li>
                                    <li>Select a reservation from the dropdown.</li>
                                    <li>Choose a food item (categorized: Breakfast, Lunch, Dinner).</li>
                                    <li>Set the quantity and click <strong>"Add Order"</strong>.</li>
                                    <li>The total food charges are automatically calculated.</li>
                                    <li>You can remove orders using the delete button.</li>
                                </ol>
                                <p>Food charges are included in the final bill when generated.</p>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128176; 6. Billing & Invoices</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <h5>Generating a Bill:</h5>
                                <ol>
                                    <li>Navigate to a reservation and click <strong>"Bill"</strong> or go to Bills > Generate.</li>
                                    <li>Review room charges and food orders.</li>
                                    <li>Select a <strong>billing type</strong>:</li>
                                    <ul>
                                        <li><strong>Standard</strong> - 10% tax on subtotal</li>
                                        <li><strong>Premium</strong> - 5% service charge + 10% tax</li>
                                        <li><strong>Discount</strong> - 10% discount then 10% tax</li>
                                    </ul>
                                    <li>Click <strong>"Generate Bill"</strong>.</li>
                                    <li>View and print the detailed invoice.</li>
                                </ol>
                                <p>Bills can be regenerated with a different billing type at any time.</p>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128200; 7. Reports & Analytics</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <h5>Revenue Report:</h5>
                                <ul>
                                    <li>Shows total bills, room revenue, food revenue, tax, discounts, and total revenue.</li>
                                    <li>Includes daily revenue breakdown.</li>
                                    <li>Filter by date range to analyze specific periods.</li>
                                </ul>
                                <h5>Occupancy Report:</h5>
                                <ul>
                                    <li>Shows occupancy rate by room type.</li>
                                    <li>Lists all rooms with current status and guest information.</li>
                                    <li>Filter by date range for historical analysis.</li>
                                </ul>
                                <p>Both reports can be <strong>printed</strong> using the Print button.</p>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <div class="accordion-header" onclick="toggleAccordion(this)">
                            <span>&#128101; 8. User Management (Admin Only)</span>
                            <span class="toggle-icon">&#9660;</span>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-body">
                                <p>Only administrators can access user management:</p>
                                <ul>
                                    <li><strong>Add User</strong> - Create new staff or admin accounts.</li>
                                    <li><strong>Edit User</strong> - Update user details, role, and status.</li>
                                    <li><strong>Reset Password</strong> - Set a new password for any user.</li>
                                    <li><strong>Deactivate</strong> - Disable user access without deleting.</li>
                                </ul>
                                <h5>User Roles:</h5>
                                <ul>
                                    <li><strong>Admin</strong> - Full system access including user management</li>
                                    <li><strong>Staff</strong> - Can manage reservations, rooms, food orders, and bills</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp"/>
    </div>
</div>

<script>
function toggleAccordion(header) {
    var item = header.parentElement;
    var wasActive = item.classList.contains('active');
    // Close all
    document.querySelectorAll('.accordion-item').forEach(function(el) {
        el.classList.remove('active');
    });
    // Toggle clicked
    if (!wasActive) {
        item.classList.add('active');
    }
}
</script>
</body>
</html>

