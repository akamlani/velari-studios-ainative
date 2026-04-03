"""velari package — sets up logging from config/logging.yaml."""

import logging
import logging.config
from pathlib import Path

import yaml

from velari.version import __version__

_CONFIG_PATH = Path(__file__).parent.parent / "config" / "logging.yaml"
_LOG_DIR = Path(__file__).parent.parent / "logs"


def _setup_logging(config_path: Path = _CONFIG_PATH) -> None:
    _LOG_DIR.mkdir(exist_ok=True)
    with open(config_path) as f:
        config = yaml.safe_load(f)
    logging.config.dictConfig(config)


_setup_logging()

logger = logging.getLogger(__name__)

__all__ = ["__version__", "logger"]
