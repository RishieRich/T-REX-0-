"""Smoke test for the empty TREXO package baseline."""


def test_trexo_package_imports() -> None:
    import trexo

    assert trexo.__name__ == "trexo"
