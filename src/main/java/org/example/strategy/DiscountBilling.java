package org.example.strategy;

public class DiscountBilling implements BillingStrategy {

    @Override
    public double calculateTax(double subtotal) {
        double discount = calculateDiscount(subtotal);
        return (subtotal - discount) * 0.10;
    }

    @Override
    public double calculateServiceCharge(double subtotal) {
        return 0;
    }

    @Override
    public double calculateDiscount(double subtotal) {
        return subtotal * 0.10;
    }

    @Override
    public double calculateTotal(double roomCharges, double foodCharges) {
        double subtotal = roomCharges + foodCharges;
        double discount = calculateDiscount(subtotal);
        double tax = (subtotal - discount) * 0.10;
        return subtotal - discount + tax;
    }

    @Override
    public String getStrategyName() {
        return "Discount";
    }
}
