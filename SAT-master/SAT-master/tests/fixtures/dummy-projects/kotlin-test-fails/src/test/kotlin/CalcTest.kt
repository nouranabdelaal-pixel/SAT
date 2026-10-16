package dummy

import kotlin.test.Test
import kotlin.test.assertEquals

class CalcTest {
    @Test
    fun adds() = assertEquals(4, add(1, 2))

    @Test
    fun doubles() = assertEquals(4, twice(2))
}
