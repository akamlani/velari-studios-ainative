"""Tests for Hydra configuration loading from config/config.yaml."""
from pathlib import Path

import pytest
from hydra import compose, initialize_config_dir
from omegaconf import DictConfig

CONFIG_DIR = str(Path(__file__).parent.parent / "config")


@pytest.fixture
def cfg() -> DictConfig:
    with initialize_config_dir(config_dir=CONFIG_DIR, version_base=None):
        return compose(config_name="config")


def test_config_loads(cfg: DictConfig) -> None:
    assert cfg is not None


def test_app_section(cfg: DictConfig) -> None:
    assert cfg.app.name == "velari-github-workflows"
    assert cfg.app.env == "development"
    assert cfg.app.debug is False


def test_logging_section(cfg: DictConfig) -> None:
    assert cfg.logging.level == "INFO"
    assert "console" in cfg.logging.handlers


def test_paths_section(cfg: DictConfig) -> None:
    assert cfg.paths.data_dir == "data"
    assert cfg.paths.output_dir == "outputs"


def test_experiment_section(cfg: DictConfig) -> None:
    assert cfg.experiment.seed == 42
    assert cfg.experiment.batch_size == 32
    assert cfg.experiment.max_epochs == 10
