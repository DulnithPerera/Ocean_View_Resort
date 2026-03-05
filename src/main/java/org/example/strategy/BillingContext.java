package org.example.strategy;

public class BillingContext {

    private BillingStrategy strategy;

    public BillingContext() {
        this.strategy = new StandardBilling();
    }

    public BillingContext(BillingStrategy strategy) {
        this.strategy = strategy;
    }

    public void setStrategy(BillingStrategy strategy) {
        this.strategy = strategy;
    }

    public BillingStrategy getStrategy() {
        return strategy;
    }

    public double calculateTotal(double roomCharges, double foodCharges) {
        return strategy.calculateTotal(roomCharges, foodCharges);
    }

    public double calculateTax(double subtotal) {
        return strategy.calculateTax(subtotal);
    }

    public double calculateServiceCharge(double subtotal) {
        return strategy.calculateServiceCharge(subtotal);
    }

    public double calculateDiscount(double subtotal) {
        return strategy.calculateDiscount(subtotal);
    }

    public String getStrategyName() {
        return strategy.getStrategyName();
    }

    public static BillingStrategy getStrategyByName(String name) {
        switch (name) {
            case "Premium":
                return new PremiumBilling();
            case "Discount":
                return new DiscountBilling();
            default:
                return new StandardBilling();
        }
    }
}

