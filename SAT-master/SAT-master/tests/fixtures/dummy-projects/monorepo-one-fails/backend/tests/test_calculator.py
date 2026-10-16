import pytest

from src.calculator import add, sub


@pytest.mark.unit
def test_add():
    assert add(1, 2) == 4


@pytest.mark.unit
def test_sub():
    assert sub(3, 1) == 2
