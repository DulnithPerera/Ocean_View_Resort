package org.example.service;

import org.example.dao.ReservationDao;
import org.example.model.Reservation;
import org.example.observer.NotificationObserver;
import org.example.observer.ReservationSubject;

import java.util.List;

public class ReservationService {

    private final ReservationDao reservationDao = new ReservationDao();
    private final ReservationSubject subject = new ReservationSubject();

    public ReservationService() {
        subject.addObserver(new NotificationObserver());
    }

    public List<Reservation> getAllReservations() {
        return reservationDao.getAll();
    }

    public Reservation getReservationById(int id) {
        return reservationDao.getById(id);
    }

    public Reservation getByReservationNumber(String reservationNumber) {
        return reservationDao.getByReservationNumber(reservationNumber);
    }

    public List<Reservation> getByStatus(String status) {
        return reservationDao.getByStatus(status);
    }

    public int createReservation(Reservation reservation) {
        int newId = reservationDao.create(reservation);
        if (newId > 0) {
            reservation.setReservationId(newId);
            subject.notifyObservers(reservation, "CREATED");
        }
        return newId;
    }

    public String getLastError() {
        return reservationDao.getLastError();
    }

    public boolean updateReservation(Reservation reservation) {
        boolean result = reservationDao.update(reservation);
        if (result) {
            subject.notifyObservers(reservation, "UPDATED");
        }
        return result;
    }

    public boolean checkIn(int reservationId) {
        boolean result = reservationDao.updateStatus(reservationId, "Checked-In");
        if (result) {
            Reservation res = reservationDao.getById(reservationId);
            if (res != null) subject.notifyObservers(res, "CHECKED_IN");
        }
        return result;
    }

    public boolean checkOut(int reservationId) {
        boolean result = reservationDao.updateStatus(reservationId, "Checked-Out");
        if (result) {
            Reservation res = reservationDao.getById(reservationId);
            if (res != null) subject.notifyObservers(res, "CHECKED_OUT");
        }
        return result;
    }

    public boolean cancelReservation(int reservationId) {
        Reservation res = reservationDao.getById(reservationId);
        boolean result = reservationDao.updateStatus(reservationId, "Cancelled");
        if (result && res != null) {
            res.setStatus("Cancelled");
            subject.notifyObservers(res, "CANCELLED");
        }
        return result;
    }

    public boolean deleteReservation(int reservationId) {
        Reservation res = reservationDao.getById(reservationId);
        boolean result = reservationDao.delete(reservationId);
        if (result && res != null) {
            subject.notifyObservers(res, "DELETED");
        }
        return result;
    }

    public String generateReservationNumber() {
        return reservationDao.generateReservationNumber();
    }

    public int getActiveCount() {
        return reservationDao.getActiveCount();
    }

    public int getTodayCheckIns() {
        return reservationDao.getTodayCheckIns();
    }

    public int getTodayCheckOuts() {
        return reservationDao.getTodayCheckOuts();
    }
}
