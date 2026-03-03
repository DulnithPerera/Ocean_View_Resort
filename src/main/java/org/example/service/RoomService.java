package org.example.service;

import org.example.dao.RoomDao;
import org.example.model.Room;

import java.sql.Date;
import java.util.List;

public class RoomService {

    private final RoomDao roomDao = new RoomDao();

    public List<Room> getAllRooms() {
        return roomDao.getAll();
    }

    public List<Room> getAvailableRooms(Date checkIn, Date checkOut) {
        return roomDao.getAvailable(checkIn, checkOut);
    }

    public Room getRoomById(int roomId) {
        return roomDao.getById(roomId);
    }

    public boolean addRoom(Room room) {
        return roomDao.add(room);
    }

    public boolean updateRoom(Room room) {
        return roomDao.update(room);
    }

    public boolean deleteRoom(int roomId) {
        return roomDao.delete(roomId);
    }

    public boolean updateRoomStatus(int roomId, String status) {
        return roomDao.updateStatus(roomId, status);
    }

    public int getTotalRooms() {
        return roomDao.getTotalRooms();
    }

    public int getAvailableRoomCount() {
        return roomDao.getCountByStatus("Available");
    }

    public int getOccupiedRoomCount() {
        return roomDao.getCountByStatus("Occupied") + roomDao.getCountByStatus("Reserved");
    }
}
