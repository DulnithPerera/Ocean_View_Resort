package org.example.model;

import java.sql.Timestamp;

public class Food {
    private int foodId;
    private String foodName;
    private String foodType;
    private double price;
    private String description;
    private boolean isAvailable;
    private Timestamp createdAt;

    public Food() {}

    public Food(int foodId, String foodName, String foodType, double price,
                String description, boolean isAvailable, Timestamp createdAt) {
        this.foodId = foodId;
        this.foodName = foodName;
        this.foodType = foodType;
        this.price = price;
        this.description = description;
        this.isAvailable = isAvailable;
        this.createdAt = createdAt;
    }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public String getFoodType() { return foodType; }
    public void setFoodType(String foodType) { this.foodType = foodType; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Food{foodId=" + foodId + ", foodName='" + foodName + "', foodType='" + foodType +
                "', price=" + price + "}";
    }
}
