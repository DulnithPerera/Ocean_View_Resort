package org.example.strategy;

public class StandardBilling implements BillingStrategy {

    @Override
    public double calculateTax(double subtotal) {
        return subtotal * 0.10;
    }

    @Override
    public double calculateServiceCharge(double subtotal) {
        return 0;
    }

    @Override
    public double calculateDiscount(double subtotal) {
        return 0;
    }

    @Override
    public double calculateTotal(double roomCharges, double foodCharges) {
        double subtotal = roomCharges + foodCharges;
        double tax = calculateTax(subtotal);
        return subtotal + tax;
    }

    @Override
    public String getStrategyName() {
        return "Standard";
    }
}
