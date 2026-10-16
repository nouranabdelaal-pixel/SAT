import unittest


class MathTests(unittest.TestCase):
    def test_add(self):
        self.assertEqual(1 + 1, 2)

    def test_wrong_on_purpose(self):
        # Fails on purpose. The message holds a fake password: the report must show password=***
        self.assertEqual(2 * 2, 5, "login used password=hunter2")


if __name__ == "__main__":
    unittest.main()
