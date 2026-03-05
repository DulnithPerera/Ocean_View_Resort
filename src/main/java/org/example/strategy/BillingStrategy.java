package org.example.strategy;

public interface BillingStrategy {
    double calculateTax(double subtotal);
    double calculateServiceCharge(double subtotal);
    double calculateDiscount(double subtotal);
    double calculateTotal(double roomCharges, double foodCharges);
    String getStrategyName();
}
