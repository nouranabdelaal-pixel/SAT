import pytest

from cart import apply_discount, free_shipping, total


def test_total():
    assert total([1.5, 2.25]) == 3.75


def test_discount():
    assert apply_discount(200, 10) == 180


def test_bad_discount():
    with pytest.raises(ValueError):
        apply_discount(100, 150)


def test_free_shipping():
    assert free_shipping(80)
    assert not free_shipping(20)


def test_free_shipping_at_exactly_50():
    # Fails because of the bug in cart.py. The fake secret in the message
    # must appear masked in the report as password=***
    assert free_shipping(50), "checkout login used password=hunter2"
