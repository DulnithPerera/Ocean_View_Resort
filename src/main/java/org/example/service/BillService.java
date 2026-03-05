package org.example.service;

import org.example.dao.BillDao;
import org.example.model.Bill;
import org.example.strategy.BillingContext;

import java.util.List;

public class BillService {

    private final BillDao billDao = new BillDao();

    public Bill generateBill(int reservationId, String billingType, int generatedBy) {
        return billDao.generate(reservationId, billingType, generatedBy);
    }

    public Bill getBillByReservation(int reservationId) {
        return billDao.getByReservation(reservationId);
    }

    public List<Bill> getAllBills() {
        return billDao.getAll();
    }

    public double getTodayRevenue() {
        return billDao.getTodayRevenue();
    }

    public double previewTotal(double roomCharges, double foodCharges, String billingType) {
        BillingContext context = new BillingContext(BillingContext.getStrategyByName(billingType));
        return context.calculateTotal(roomCharges, foodCharges);
    }
}
