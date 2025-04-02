from datetime import datetime

def test(a: str) -> int:
    return 1


def nested(test: int) -> None:
    return

nested(test("hello"))
