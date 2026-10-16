import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import cart  # noqa: E402


class CartTests(unittest.TestCase):
    def test_total(self):
        self.assertEqual(cart.total([1.5, 2.25]), 3.75)

    def test_discount(self):
        self.assertEqual(cart.apply_discount(200, 10), 180)

    def test_bad_discount(self):
        with self.assertRaises(ValueError):
            cart.apply_discount(100, 150)


if __name__ == "__main__":
    unittest.main()
