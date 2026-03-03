package org.example.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ReservationFood {
    private int id;
    private int reservationId;
    private int foodId;
    private int quantity;
    private Date orderDate;
    private double totalPrice;
    private Timestamp createdAt;

    private String foodName;
    private String foodType;
    private double unitPrice;
    private String reservationNumber;

    public ReservationFood() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public String getFoodType() { return foodType; }
    public void setFoodType(String foodType) { this.foodType = foodType; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    @Override
    public String toString() {
        return "ReservationFood{id=" + id + ", reservationId=" + reservationId +
                ", foodId=" + foodId + ", quantity=" + quantity + ", totalPrice=" + totalPrice + "}";
    }
}
