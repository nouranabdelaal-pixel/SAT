package shop;

/** Small shopping-cart helpers. */
public final class Cart {
    private Cart() {
    }

    /** Sum of prices in cents. */
    public static long total(long[] cents) {
        long sum = 0;
        for (long c : cents) {
            sum += c;
        }
        return sum;
    }

    /** Amount after a percent discount (0-100). */
    public static long applyDiscount(long cents, int percent) {
        if (percent < 0 || percent > 100) {
            throw new IllegalArgumentException("percent must be 0-100");
        }
        return cents * (100 - percent) / 100;
    }
}
