package org.example.model;

import java.sql.Timestamp;

public class Bill {
    private int billId;
    private int reservationId;
    private double roomCharges;
    private double foodCharges;
    private double serviceCharge;
    private double tax;
    private double discount;
    private double totalAmount;
    private String billingType;
    private int generatedBy;
    private Timestamp createdAt;

    private String reservationNumber;
    private String guestName;
    private String roomNumber;
    private String roomType;
    private long nights;
    private double ratePerNight;
    private String generatedByName;

    public Bill() {}

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public double getRoomCharges() { return roomCharges; }
    public void setRoomCharges(double roomCharges) { this.roomCharges = roomCharges; }

    public double getFoodCharges() { return foodCharges; }
    public void setFoodCharges(double foodCharges) { this.foodCharges = foodCharges; }

    public double getServiceCharge() { return serviceCharge; }
    public void setServiceCharge(double serviceCharge) { this.serviceCharge = serviceCharge; }

    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getBillingType() { return billingType; }
    public void setBillingType(String billingType) { this.billingType = billingType; }

    public int getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(int generatedBy) { this.generatedBy = generatedBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public long getNights() { return nights; }
    public void setNights(long nights) { this.nights = nights; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getGeneratedByName() { return generatedByName; }
    public void setGeneratedByName(String generatedByName) { this.generatedByName = generatedByName; }

    public double getSubtotal() { return roomCharges + foodCharges; }

    @Override
    public String toString() {
        return "Bill{billId=" + billId + ", reservationId=" + reservationId +
                ", totalAmount=" + totalAmount + ", billingType='" + billingType + "'}";
    }
}
