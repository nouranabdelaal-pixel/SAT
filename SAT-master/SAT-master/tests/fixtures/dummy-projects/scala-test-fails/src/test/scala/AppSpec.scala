import org.scalatest.funsuite.AnyFunSuite

class AppSpec extends AnyFunSuite {
  test("adds") { assert(App.add(1, 2) == 4) }
  test("doubles") { assert(App.twice(2) == 4) }
}
