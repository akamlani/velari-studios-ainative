"""Tests for Hydra configuration loading."""
from pathlib import Path

from omegaconf import OmegaConf


CONFIG_PATH = Path(__file__).parent.parent / "config" / "config.yaml"


def test_config_file_exists():
    assert CONFIG_PATH.exists(), f"config.yaml not found at {CONFIG_PATH}"


def test_config_loads():
    cfg = OmegaConf.load(CONFIG_PATH)
    assert cfg is not None


def test_config_app_section():
    cfg = OmegaConf.load(CONFIG_PATH)
    assert "app" in cfg
    assert cfg.app.name == "velari-github-workflows"
    assert cfg.app.version == "0.1.0"
    assert cfg.app.debug is False


def test_config_data_section():
    cfg = OmegaConf.load(CONFIG_PATH)
    assert "data" in cfg
    assert cfg.data.raw_dir == "data/raw"
    assert cfg.data.processed_dir == "data/processed"
    assert cfg.data.output_dir == "data/output"


def test_config_training_section():
    cfg = OmegaConf.load(CONFIG_PATH)
    assert "training" in cfg
    assert cfg.training.seed == 42
    assert cfg.training.epochs == 10
    assert cfg.training.batch_size == 32
    assert cfg.training.learning_rate == 1e-3


def test_config_logging_section():
    cfg = OmegaConf.load(CONFIG_PATH)
    assert "logging" in cfg
    assert cfg.logging.level == "INFO"
