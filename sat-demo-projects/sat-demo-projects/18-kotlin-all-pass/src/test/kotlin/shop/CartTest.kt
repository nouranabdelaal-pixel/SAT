package shop

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class CartTest {
    @Test
    fun total() {
        assertEquals(375L, Cart.total(listOf(150L, 225L)))
    }

    @Test
    fun discount() {
        assertEquals(18000L, Cart.applyDiscount(20000L, 10))
    }

    @Test
    fun badDiscount() {
        assertFailsWith<IllegalArgumentException> { Cart.applyDiscount(100L, 150) }
    }
}
