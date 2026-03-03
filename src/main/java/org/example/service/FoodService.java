package org.example.service;

import org.example.dao.FoodDao;
import org.example.dao.ReservationFoodDao;
import org.example.model.Food;
import org.example.model.ReservationFood;

import java.util.List;

public class FoodService {

    private final FoodDao foodDao = new FoodDao();
    private final ReservationFoodDao reservationFoodDao = new ReservationFoodDao();

    public List<Food> getAllFoods() {
        return foodDao.getAll();
    }

    public List<Food> getAvailableFoods() {
        return foodDao.getAvailable();
    }

    public List<Food> getFoodsByType(String type) {
        return foodDao.getByType(type);
    }

    public Food getFoodById(int foodId) {
        return foodDao.getById(foodId);
    }

    public boolean addFood(Food food) {
        return foodDao.add(food);
    }

    public boolean updateFood(Food food) {
        return foodDao.update(food);
    }

    public boolean deleteFood(int foodId) {
        return foodDao.delete(foodId);
    }

    public List<ReservationFood> getFoodOrdersByReservation(int reservationId) {
        return reservationFoodDao.getByReservation(reservationId);
    }

    public boolean addFoodOrder(ReservationFood order) {
        Food food = foodDao.getById(order.getFoodId());
        if (food != null) {
            order.setTotalPrice(food.getPrice() * order.getQuantity());
        }
        return reservationFoodDao.add(order);
    }

    public boolean deleteFoodOrder(int id) {
        return reservationFoodDao.delete(id);
    }

    public double getTotalFoodCharges(int reservationId) {
        return reservationFoodDao.getTotalFoodCharges(reservationId);
    }
}
