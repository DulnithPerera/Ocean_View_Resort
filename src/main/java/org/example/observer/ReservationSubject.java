package org.example.observer;

import org.example.model.Reservation;
import java.util.ArrayList;
import java.util.List;

public class ReservationSubject {

    private final List<ReservationObserver> observers = new ArrayList<>();

    public void addObserver(ReservationObserver observer) {
        observers.add(observer);
    }

    public void removeObserver(ReservationObserver observer) {
        observers.remove(observer);
    }

    public void notifyObservers(Reservation reservation, String eventType) {
        for (ReservationObserver observer : observers) {
            observer.onReservationEvent(reservation, eventType);
        }
    }
}
