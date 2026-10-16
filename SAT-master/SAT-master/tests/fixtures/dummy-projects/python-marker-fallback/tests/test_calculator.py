from src.calculator import add, sub


def test_add():
    assert add(1, 2) == 3


def test_sub():
    assert sub(3, 1) == 2
