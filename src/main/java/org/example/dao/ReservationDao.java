package org.example.dao;

import org.example.model.ModelFactory;
import org.example.model.Reservation;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDao {

    private String lastError = null;

    public String getLastError() {
        return lastError;
    }

    private static final String SELECT_WITH_JOINS =
            "SELECT r.*, rm.room_number, rm.room_type, rm.rate_per_night, u.full_name AS created_by_name " +
            "FROM Reservations r " +
            "INNER JOIN Rooms rm ON r.room_id = rm.room_id " +
            "INNER JOIN Users u ON r.created_by = u.user_id ";

    public List<Reservation> getAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + "ORDER BY r.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(ModelFactory.createReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Reservation getById(int reservationId) {
        String sql = SELECT_WITH_JOINS + "WHERE r.reservation_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return ModelFactory.createReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Reservation getByReservationNumber(String reservationNumber) {
        String sql = SELECT_WITH_JOINS + "WHERE r.reservation_number = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reservationNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return ModelFactory.createReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Reservation> getByStatus(String status) {
        List<Reservation> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + "WHERE r.status = ? ORDER BY r.check_in_date";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(ModelFactory.createReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int create(Reservation res) {
        lastError = null;
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            if (conn == null) {
                System.out.println("ERROR: Database connection is null. Cannot create reservation.");
                lastError = "Database connection failed. Check SQL Server is running and credentials are correct.";
                return -1;
            }
            conn.setAutoCommit(false);

            System.out.println("=== CREATING RESERVATION ===");
            System.out.println("ReservationNumber: " + res.getReservationNumber());
            System.out.println("GuestName: " + res.getGuestName());
            System.out.println("RoomId: " + res.getRoomId());
            System.out.println("CheckIn: " + res.getCheckInDate());
            System.out.println("CheckOut: " + res.getCheckOutDate());
            System.out.println("CreatedBy: " + res.getCreatedBy());

            // Direct SQL insert - try with created_at first, then without
            String[] insertSqls = {
                "INSERT INTO Reservations (reservation_number, guest_name, address, contact_number, " +
                    "email, room_id, check_in_date, check_out_date, num_guests, special_requests, status, created_by, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Confirmed', ?, GETDATE())",
                "INSERT INTO Reservations (reservation_number, guest_name, address, contact_number, " +
                    "email, room_id, check_in_date, check_out_date, num_guests, special_requests, status, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Confirmed', ?)"
            };

            int newId = -1;
            for (String insertSql : insertSqls) {
                try (PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, res.getReservationNumber());
                    stmt.setString(2, res.getGuestName());
                    stmt.setString(3, res.getAddress());
                    stmt.setString(4, res.getContactNumber());
                    stmt.setString(5, res.getEmail());
                    stmt.setInt(6, res.getRoomId());
                    stmt.setDate(7, res.getCheckInDate());
                    stmt.setDate(8, res.getCheckOutDate());
                    stmt.setInt(9, res.getNumGuests());
                    stmt.setString(10, res.getSpecialRequests() != null ? res.getSpecialRequests() : "");
                    stmt.setInt(11, res.getCreatedBy());

                    int affected = stmt.executeUpdate();
                    System.out.println("INSERT affected rows: " + affected);

                    if (affected > 0) {
                        try {
                            ResultSet keys = stmt.getGeneratedKeys();
                            if (keys.next()) {
                                newId = keys.getInt(1);
                            }
                        } catch (SQLException e) {
                            System.out.println("Could not get generated keys: " + e.getMessage());
                        }
                        if (newId <= 0) {
                            try (PreparedStatement idStmt = conn.prepareStatement("SELECT SCOPE_IDENTITY() AS new_id");
                                 ResultSet idRs = idStmt.executeQuery()) {
                                if (idRs.next()) {
                                    newId = idRs.getInt("new_id");
                                }
                            }
                        }
                        if (newId <= 0) newId = 1;
                        break; // success, exit loop
                    }
                } catch (SQLException insertEx) {
                    lastError = insertEx.getMessage();
                    System.out.println("INSERT attempt failed: " + insertEx.getMessage());
                    // Try the next SQL variant
                }
            }

            if (newId <= 0) {
                System.out.println("All INSERT attempts failed.");
                lastError = "All INSERT attempts failed. Check server console for SQL errors.";
                conn.rollback();
                return -1;
            }

            // Update room status to 'Reserved'
            try (PreparedStatement updateRoom = conn.prepareStatement(
                    "UPDATE Rooms SET status = 'Reserved' WHERE room_id = ?")) {
                updateRoom.setInt(1, res.getRoomId());
                updateRoom.executeUpdate();
            }

            conn.commit();
            System.out.println("Reservation created successfully with ID: " + newId);
            return newId;

        } catch (Exception e) {
            lastError = e.getMessage();
            System.out.println("Error creating reservation: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return -1;
    }

    public boolean update(Reservation res) {
        String sql = "UPDATE Reservations SET guest_name=?, address=?, contact_number=?, email=?, " +
                "room_id=?, check_in_date=?, check_out_date=?, num_guests=?, special_requests=?, " +
                "status=?, updated_at=GETDATE() WHERE reservation_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, res.getGuestName());
            stmt.setString(2, res.getAddress());
            stmt.setString(3, res.getContactNumber());
            stmt.setString(4, res.getEmail());
            stmt.setInt(5, res.getRoomId());
            stmt.setDate(6, res.getCheckInDate());
            stmt.setDate(7, res.getCheckOutDate());
            stmt.setInt(8, res.getNumGuests());
            stmt.setString(9, res.getSpecialRequests());
            stmt.setString(10, res.getStatus());
            stmt.setInt(11, res.getReservationId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int reservationId, String status) {
        String sql = "UPDATE Reservations SET status=?, updated_at=GETDATE() WHERE reservation_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int reservationId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            if (conn == null) {
                System.out.println("ERROR: Database connection is null. Cannot delete reservation.");
                return false;
            }
            conn.setAutoCommit(false);

            // Get room_id before deleting
            int roomId = -1;
            try (PreparedStatement getRoomStmt = conn.prepareStatement(
                    "SELECT room_id FROM Reservations WHERE reservation_id = ?")) {
                getRoomStmt.setInt(1, reservationId);
                ResultSet rs = getRoomStmt.executeQuery();
                if (rs.next()) roomId = rs.getInt("room_id");
            }

            // Delete from ReservationFoods
            try (PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM ReservationFoods WHERE reservation_id = ?")) {
                stmt.setInt(1, reservationId);
                stmt.executeUpdate();
            }

            // Delete from Bills
            try (PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM Bills WHERE reservation_id = ?")) {
                stmt.setInt(1, reservationId);
                stmt.executeUpdate();
            }

            // Delete the reservation
            int result;
            try (PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM Reservations WHERE reservation_id = ?")) {
                stmt.setInt(1, reservationId);
                result = stmt.executeUpdate();
            }

            // Update room status back to Available
            if (roomId > 0) {
                try (PreparedStatement updateRoom = conn.prepareStatement(
                        "UPDATE Rooms SET status = 'Available' WHERE room_id = ?")) {
                    updateRoom.setInt(1, roomId);
                    updateRoom.executeUpdate();
                }
            }

            conn.commit();
            return result > 0;
        } catch (Exception e) {
            System.out.println("Error deleting reservation: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public String generateReservationNumber() {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            if (conn == null) {
                return "OVR-" + System.currentTimeMillis();
            }
            // Try the database function first
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT dbo.fn_GenerateReservationNumber() AS res_num");
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String num = rs.getString("res_num");
                    if (num != null && !num.isEmpty()) return num;
                }
            } catch (SQLException e) {
                System.out.println("fn_GenerateReservationNumber not available, generating manually: " + e.getMessage());
            }
            // Fallback: generate manually in format OVR-YYYYMMDD-XXXX
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT ISNULL(MAX(reservation_id), 0) + 1 AS next_id FROM Reservations");
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int nextId = rs.getInt("next_id");
                    java.time.LocalDate today = java.time.LocalDate.now();
                    String dateStr = today.format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
                    return String.format("OVR-%s-%04d", dateStr, nextId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        // Last resort fallback
        return "OVR-" + System.currentTimeMillis();
    }

    public int getActiveCount() {
        String sql = "SELECT COUNT(*) FROM Reservations WHERE status IN ('Confirmed', 'Checked-In')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTodayCheckIns() {
        String sql = "SELECT COUNT(*) FROM Reservations WHERE check_in_date = CAST(GETDATE() AS DATE) AND status = 'Confirmed'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTodayCheckOuts() {
        String sql = "SELECT COUNT(*) FROM Reservations WHERE check_out_date = CAST(GETDATE() AS DATE) AND status = 'Checked-In'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
