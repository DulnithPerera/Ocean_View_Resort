package org.example.model;

import java.sql.Timestamp;

public class Room {
    private int roomId;
    private String roomNumber;
    private String roomType;
    private double ratePerNight;
    private String status;
    private int floor;
    private String description;
    private int maxGuests;
    private Timestamp createdAt;

    public Room() {}

    public Room(int roomId, String roomNumber, String roomType, double ratePerNight,
                String status, int floor, String description, int maxGuests, Timestamp createdAt) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.ratePerNight = ratePerNight;
        this.status = status;
        this.floor = floor;
        this.description = description;
        this.maxGuests = maxGuests;
        this.createdAt = createdAt;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getMaxGuests() { return maxGuests; }
    public void setMaxGuests(int maxGuests) { this.maxGuests = maxGuests; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Room{roomId=" + roomId + ", roomNumber='" + roomNumber + "', roomType='" + roomType +
                "', ratePerNight=" + ratePerNight + ", status='" + status + "'}";
    }
}
