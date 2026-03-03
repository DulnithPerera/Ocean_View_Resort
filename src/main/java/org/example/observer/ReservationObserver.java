package org.example.observer;

import org.example.model.Reservation;

public interface ReservationObserver {
    void onReservationEvent(Reservation reservation, String eventType);
}
