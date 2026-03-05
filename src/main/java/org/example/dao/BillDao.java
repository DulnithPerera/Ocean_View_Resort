package org.example.dao;

import org.example.model.Bill;
import org.example.model.ModelFactory;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDao {

    private static final String SELECT_WITH_JOINS =
            "SELECT b.*, r.reservation_number, r.guest_name, rm.room_number, rm.room_type, " +
            "rm.rate_per_night, u.full_name AS generated_by_name " +
            "FROM Bills b " +
            "INNER JOIN Reservations r ON b.reservation_id = r.reservation_id " +
            "INNER JOIN Rooms rm ON r.room_id = rm.room_id " +
            "LEFT JOIN Users u ON b.generated_by = u.user_id ";

    public Bill generate(int reservationId, String billingType, int generatedBy) {
        String sql = "{CALL sp_CalculateBill(?, ?, ?)}";
        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, reservationId);
            stmt.setString(2, billingType);
            stmt.setInt(3, generatedBy);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setRoomCharges(rs.getDouble("room_charges"));
                bill.setFoodCharges(rs.getDouble("food_charges"));
                bill.setServiceCharge(rs.getDouble("service_charge"));
                bill.setTax(rs.getDouble("tax"));
                bill.setDiscount(rs.getDouble("discount"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillingType(rs.getString("billing_type"));
                bill.setGeneratedBy(rs.getInt("generated_by"));
                bill.setCreatedAt(rs.getTimestamp("created_at"));
                return bill;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Bill getByReservation(int reservationId) {
        String sql = SELECT_WITH_JOINS + "WHERE b.reservation_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return ModelFactory.createBill(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Bill> getAll() {
        List<Bill> bills = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + "ORDER BY b.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                bills.add(ModelFactory.createBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    public double getTodayRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM Bills WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
