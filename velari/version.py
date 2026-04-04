def _read_version_from_installed_metadata() -> str | None:
    """Read version from installed package metadata."""
    try:
        from importlib.metadata import version, PackageNotFoundError
        return version("velari-github-workflows")
    except Exception:
        return None


def _read_version_from_pyproject() -> str | None:
    """Read version from pyproject.toml."""
    try:
        import tomllib
        from pathlib import Path
        root = Path(__file__).parent.parent
        with open(root / "pyproject.toml", "rb") as f:
            data = tomllib.load(f)
        return data["project"]["version"]
    except Exception:
        return None


__version__ = (
    _read_version_from_installed_metadata()
    or _read_version_from_pyproject()
    or "0.0.0"
)
