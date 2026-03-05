package org.example.dao;

import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDao {

    public Map<String, Object> getRevenueReport(Date startDate, Date endDate) {
        Map<String, Object> report = new HashMap<>();
        String sql = "{CALL sp_GetRevenueReport(?, ?)}";
        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            boolean hasResults = stmt.execute();

            if (hasResults) {
                ResultSet rs = stmt.getResultSet();
                if (rs.next()) {
                    report.put("totalBills", rs.getInt("total_bills"));
                    report.put("totalRoomRevenue", rs.getDouble("total_room_revenue"));
                    report.put("totalFoodRevenue", rs.getDouble("total_food_revenue"));
                    report.put("totalServiceCharges", rs.getDouble("total_service_charges"));
                    report.put("totalTax", rs.getDouble("total_tax"));
                    report.put("totalDiscounts", rs.getDouble("total_discounts"));
                    report.put("totalRevenue", rs.getDouble("total_revenue"));
                }
            }

            if (stmt.getMoreResults()) {
                ResultSet rs = stmt.getResultSet();
                List<Map<String, Object>> dailyData = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> day = new HashMap<>();
                    day.put("date", rs.getDate("report_date"));
                    day.put("reservations", rs.getInt("reservations"));
                    day.put("revenue", rs.getDouble("daily_revenue"));
                    dailyData.add(day);
                }
                report.put("dailyBreakdown", dailyData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }

    public Map<String, Object> getOccupancyReport(Date startDate, Date endDate) {
        Map<String, Object> report = new HashMap<>();
        String sql = "{CALL sp_GetOccupancyReport(?, ?)}";
        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            boolean hasResults = stmt.execute();

            if (hasResults) {
                ResultSet rs = stmt.getResultSet();
                List<Map<String, Object>> typeData = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> type = new HashMap<>();
                    type.put("roomType", rs.getString("room_type"));
                    type.put("totalRooms", rs.getInt("total_rooms"));
                    type.put("occupiedRooms", rs.getInt("occupied_rooms"));
                    type.put("occupancyRate", rs.getDouble("occupancy_rate"));
                    typeData.add(type);
                }
                report.put("byRoomType", typeData);
            }

            if (stmt.getMoreResults()) {
                ResultSet rs = stmt.getResultSet();
                List<Map<String, Object>> roomData = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> room = new HashMap<>();
                    room.put("roomNumber", rs.getString("room_number"));
                    room.put("roomType", rs.getString("room_type"));
                    room.put("ratePerNight", rs.getDouble("rate_per_night"));
                    room.put("status", rs.getString("status"));
                    room.put("guestName", rs.getString("guest_name"));
                    room.put("checkInDate", rs.getDate("check_in_date"));
                    room.put("checkOutDate", rs.getDate("check_out_date"));
                    room.put("reservationStatus", rs.getString("reservation_status"));
                    roomData.add(room);
                }
                report.put("roomDetails", roomData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }
}

