package org.example.dao;

import org.example.model.Food;
import org.example.model.ModelFactory;
import org.example.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodDao {

    public List<Food> getAll() {
        List<Food> foods = new ArrayList<>();
        String sql = "SELECT * FROM Foods ORDER BY food_type, food_name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                foods.add(ModelFactory.createFood(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return foods;
    }

    public List<Food> getByType(String foodType) {
        List<Food> foods = new ArrayList<>();
        String sql = "SELECT * FROM Foods WHERE food_type = ? AND is_available = 1 ORDER BY food_name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, foodType);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                foods.add(ModelFactory.createFood(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return foods;
    }

    public List<Food> getAvailable() {
        List<Food> foods = new ArrayList<>();
        String sql = "SELECT * FROM Foods WHERE is_available = 1 ORDER BY food_type, food_name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                foods.add(ModelFactory.createFood(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return foods;
    }

    public Food getById(int foodId) {
        String sql = "SELECT * FROM Foods WHERE food_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, foodId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return ModelFactory.createFood(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(Food food) {
        String sql = "INSERT INTO Foods (food_name, food_type, price, description, is_available) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, food.getFoodName());
            stmt.setString(2, food.getFoodType());
            stmt.setDouble(3, food.getPrice());
            stmt.setString(4, food.getDescription());
            stmt.setBoolean(5, food.isAvailable());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Food food) {
        String sql = "UPDATE Foods SET food_name=?, food_type=?, price=?, description=?, is_available=? WHERE food_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, food.getFoodName());
            stmt.setString(2, food.getFoodType());
            stmt.setDouble(3, food.getPrice());
            stmt.setString(4, food.getDescription());
            stmt.setBoolean(5, food.isAvailable());
            stmt.setInt(6, food.getFoodId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int foodId) {
        String sql = "DELETE FROM Foods WHERE food_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, foodId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
