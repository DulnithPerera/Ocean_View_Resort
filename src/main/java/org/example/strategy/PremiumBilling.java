package org.example.strategy;

public class PremiumBilling implements BillingStrategy {

    @Override
    public double calculateTax(double subtotal) {
        double serviceCharge = calculateServiceCharge(subtotal);
        return (subtotal + serviceCharge) * 0.10;
    }

    @Override
    public double calculateServiceCharge(double subtotal) {
        return subtotal * 0.05;
    }

    @Override
    public double calculateDiscount(double subtotal) {
        return 0;
    }

    @Override
    public double calculateTotal(double roomCharges, double foodCharges) {
        double subtotal = roomCharges + foodCharges;
        double serviceCharge = calculateServiceCharge(subtotal);
        double tax = (subtotal + serviceCharge) * 0.10;
        return subtotal + serviceCharge + tax;
    }

    @Override
    public String getStrategyName() {
        return "Premium";
    }
}
