def total(prices):
    return round(sum(prices), 2)


def apply_discount(amount, percent):
    if not 0 <= percent <= 100:
        raise ValueError("percent must be 0-100")
    return round(amount * (100 - percent) / 100, 2)
