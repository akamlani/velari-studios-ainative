"""Example demonstrating Hydra configuration loading from config/config.yaml."""
import hydra
from omegaconf import DictConfig, OmegaConf


@hydra.main(version_base=None, config_path="../config", config_name="config")
def main(cfg: DictConfig) -> None:
    print("Loaded configuration:")
    print(OmegaConf.to_yaml(cfg))

    print(f"App name:        {cfg.app.name}")
    print(f"Environment:     {cfg.app.env}")
    print(f"Log level:       {cfg.logging.level}")
    print(f"Experiment seed: {cfg.experiment.seed}")
    print(f"Batch size:      {cfg.experiment.batch_size}")


if __name__ == "__main__":
    main()
