package org.example.dao;

import org.example.model.ModelFactory;
import org.example.model.ReservationFood;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationFoodDao {

    public List<ReservationFood> getByReservation(int reservationId) {
        List<ReservationFood> list = new ArrayList<>();
        String sql = "SELECT rf.*, f.food_name, f.food_type, f.price, r.reservation_number " +
                "FROM ReservationFoods rf " +
                "INNER JOIN Foods f ON rf.food_id = f.food_id " +
                "INNER JOIN Reservations r ON rf.reservation_id = r.reservation_id " +
                "WHERE rf.reservation_id = ? ORDER BY rf.order_date DESC, f.food_type";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(ModelFactory.createReservationFood(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean add(ReservationFood rf) {
        String sql = "INSERT INTO ReservationFoods (reservation_id, food_id, quantity, order_date, total_price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, rf.getReservationId());
            stmt.setInt(2, rf.getFoodId());
            stmt.setInt(3, rf.getQuantity());
            stmt.setDate(4, rf.getOrderDate());
            stmt.setDouble(5, rf.getTotalPrice());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM ReservationFoods WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalFoodCharges(int reservationId) {
        String sql = "SELECT dbo.fn_CalculateFoodCharges(?) AS total";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
