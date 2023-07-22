import pytest
from quizgen.quizgen import Generator


@pytest.fixture
def validator():
    return Generator(api_key="test_api_key")
