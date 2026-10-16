import pytest

from src.app import app


@pytest.fixture
def client():
    return app.test_client()


@pytest.mark.unit
def test_health(client):
    assert client.get("/health").get_json() == {"status": "ok"}


@pytest.mark.unit
def test_add(client):
    assert client.get("/add/1/2").get_json() == {"sum": 3}
