package org.example.observer;

import org.example.model.Reservation;

public class NotificationObserver implements ReservationObserver {

    @Override
    public void onReservationEvent(Reservation reservation, String eventType) {
        String message;
        switch (eventType) {
            case "CREATED":
                message = String.format("New reservation %s created for guest %s",
                        reservation.getReservationNumber(), reservation.getGuestName());
                break;
            case "CHECKED_IN":
                message = String.format("Guest %s has checked in (Reservation: %s)",
                        reservation.getGuestName(), reservation.getReservationNumber());
                break;
            case "CHECKED_OUT":
                message = String.format("Guest %s has checked out (Reservation: %s)",
                        reservation.getGuestName(), reservation.getReservationNumber());
                break;
            case "CANCELLED":
                message = String.format("Reservation %s for guest %s has been cancelled",
                        reservation.getReservationNumber(), reservation.getGuestName());
                break;
            case "UPDATED":
                message = String.format("Reservation %s has been updated",
                        reservation.getReservationNumber());
                break;
            case "DELETED":
                message = String.format("Reservation %s has been deleted",
                        reservation.getReservationNumber());
                break;
            default:
                message = String.format("Reservation event [%s] for %s",
                        eventType, reservation.getReservationNumber());
        }
        System.out.println("[NOTIFICATION] " + message);
    }
}
