package dummy;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class CalcTest {
  @Test
  void adds() {
    assertEquals(4, Calc.add(1, 2));
  }

  @Test
  void multiplies() {
    assertEquals(6, Calc.mul(2, 3));
  }
}
