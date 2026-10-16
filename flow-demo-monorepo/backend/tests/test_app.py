def test_health():
    from app import health
    assert health() == "ok"
