package shop;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

class CartTest {
    @Test
    void total() {
        assertEquals(375, Cart.total(new long[] {150, 225}));
    }

    @Test
    void discount() {
        assertEquals(18000, Cart.applyDiscount(20000, 10));
    }

    @Test
    void badDiscount() {
        assertThrows(IllegalArgumentException.class, () -> Cart.applyDiscount(100, 150));
    }
}
