"""Example demonstrating Hydra configuration loading."""
import hydra
from omegaconf import DictConfig, OmegaConf


@hydra.main(version_base=None, config_path="../config", config_name="config")
def main(cfg: DictConfig) -> None:
    print("Loaded configuration:")
    print(OmegaConf.to_yaml(cfg))

    print(f"App name:       {cfg.app.name}")
    print(f"App version:    {cfg.app.version}")
    print(f"Debug mode:     {cfg.app.debug}")
    print(f"Training seed:  {cfg.training.seed}")
    print(f"Batch size:     {cfg.training.batch_size}")
    print(f"Learning rate:  {cfg.training.learning_rate}")


if __name__ == "__main__":
    main()
