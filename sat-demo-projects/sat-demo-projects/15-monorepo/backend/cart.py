"""Small shopping-cart helpers."""


def total(prices):
    """Sum of prices, rounded to cents."""
    return round(sum(prices), 2)


def apply_discount(amount, percent):
    """Amount after a percent discount (0-100)."""
    if not 0 <= percent <= 100:
        raise ValueError("percent must be between 0 and 100")
    return round(amount * (100 - percent) / 100, 2)


def free_shipping(amount):
    """Orders of 50 or more ship free."""
    return amount >= 50
