package shop

/** Small shopping-cart helpers. */
object Cart {
    /** Sum of prices in cents. */
    fun total(cents: List<Long>): Long = cents.sum()

    /** Amount after a percent discount (0-100). */
    fun applyDiscount(
        cents: Long,
        percent: Int,
    ): Long {
        require(percent in 0..100) { "percent must be 0-100" }
        return cents * (100 - percent) / 100
    }
}
