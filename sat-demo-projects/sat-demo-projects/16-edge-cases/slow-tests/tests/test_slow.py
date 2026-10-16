import time
import unittest


class SlowTests(unittest.TestCase):
    def test_slow(self):
        time.sleep(120)  # 2 minutes: longer than --timeout-tests 20s
        self.assertTrue(True)


if __name__ == "__main__":
    unittest.main()
