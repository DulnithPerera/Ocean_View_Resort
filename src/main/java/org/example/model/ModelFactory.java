package org.example.model;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ModelFactory {

    private ModelFactory() {
    }

    public static User createUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        try {
            user.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
        }
        try {
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
        }
        return user;
    }

    public static Room createRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRatePerNight(rs.getDouble("rate_per_night"));
        room.setStatus(rs.getString("status"));
        room.setFloor(rs.getInt("floor"));
        room.setDescription(rs.getString("description"));
        room.setMaxGuests(rs.getInt("max_guests"));
        room.setCreatedAt(rs.getTimestamp("created_at"));
        return room;
    }

    public static Reservation createReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setReservationNumber(rs.getString("reservation_number"));
        res.setGuestName(rs.getString("guest_name"));
        res.setAddress(rs.getString("address"));
        res.setContactNumber(rs.getString("contact_number"));
        res.setEmail(rs.getString("email"));
        res.setRoomId(rs.getInt("room_id"));
        res.setCheckInDate(rs.getDate("check_in_date"));
        res.setCheckOutDate(rs.getDate("check_out_date"));
        res.setNumGuests(rs.getInt("num_guests"));
        res.setStatus(rs.getString("status"));
        res.setSpecialRequests(rs.getString("special_requests"));
        res.setCreatedBy(rs.getInt("created_by"));
        res.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            res.setRoomNumber(rs.getString("room_number"));
            res.setRoomType(rs.getString("room_type"));
            res.setRatePerNight(rs.getDouble("rate_per_night"));
        } catch (SQLException e) {
        }
        try {
            res.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException e) {
        }
        return res;
    }

    public static Food createFood(ResultSet rs) throws SQLException {
        Food food = new Food();
        food.setFoodId(rs.getInt("food_id"));
        food.setFoodName(rs.getString("food_name"));
        food.setFoodType(rs.getString("food_type"));
        food.setPrice(rs.getDouble("price"));
        food.setDescription(rs.getString("description"));
        food.setAvailable(rs.getBoolean("is_available"));
        food.setCreatedAt(rs.getTimestamp("created_at"));
        return food;
    }

    public static ReservationFood createReservationFood(ResultSet rs) throws SQLException {
        ReservationFood rf = new ReservationFood();
        rf.setId(rs.getInt("id"));
        rf.setReservationId(rs.getInt("reservation_id"));
        rf.setFoodId(rs.getInt("food_id"));
        rf.setQuantity(rs.getInt("quantity"));
        rf.setOrderDate(rs.getDate("order_date"));
        rf.setTotalPrice(rs.getDouble("total_price"));
        rf.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            rf.setFoodName(rs.getString("food_name"));
            rf.setFoodType(rs.getString("food_type"));
            rf.setUnitPrice(rs.getDouble("price"));
        } catch (SQLException e) {
        }
        try {
            rf.setReservationNumber(rs.getString("reservation_number"));
        } catch (SQLException e) {
        }
        return rf;
    }

    public static Bill createBill(ResultSet rs) throws SQLException {
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
        try {
            bill.setReservationNumber(rs.getString("reservation_number"));
            bill.setGuestName(rs.getString("guest_name"));
            bill.setRoomNumber(rs.getString("room_number"));
            bill.setRoomType(rs.getString("room_type"));
            bill.setRatePerNight(rs.getDouble("rate_per_night"));
        } catch (SQLException e) {
        }
        try {
            bill.setGeneratedByName(rs.getString("generated_by_name"));
        } catch (SQLException e) {
        }
        return bill;
    }
}
