package org.example.dao;

import org.example.model.ModelFactory;
import org.example.model.Room;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDao {

    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms ORDER BY room_number";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                rooms.add(ModelFactory.createRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public List<Room> getAvailable(Date checkIn, Date checkOut) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE status != 'Maintenance' AND room_id NOT IN " +
                "(SELECT room_id FROM Reservations WHERE status IN ('Confirmed', 'Checked-In') " +
                "AND check_in_date < ? AND check_out_date > ?) ORDER BY room_number";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, checkOut);
            stmt.setDate(2, checkIn);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                rooms.add(ModelFactory.createRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public Room getById(int roomId) {
        String sql = "SELECT * FROM Rooms WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return ModelFactory.createRoom(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(Room room) {
        String sql = "INSERT INTO Rooms (room_number, room_type, rate_per_night, status, floor, description, max_guests) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getRatePerNight());
            stmt.setString(4, room.getStatus());
            stmt.setInt(5, room.getFloor());
            stmt.setString(6, room.getDescription());
            stmt.setInt(7, room.getMaxGuests());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Room room) {
        String sql = "UPDATE Rooms SET room_number=?, room_type=?, rate_per_night=?, status=?, floor=?, description=?, max_guests=? WHERE room_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getRatePerNight());
            stmt.setString(4, room.getStatus());
            stmt.setInt(5, room.getFloor());
            stmt.setString(6, room.getDescription());
            stmt.setInt(7, room.getMaxGuests());
            stmt.setInt(8, room.getRoomId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int roomId) {
        String sql = "DELETE FROM Rooms WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int roomId, String status) {
        String sql = "UPDATE Rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE status = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms";
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
