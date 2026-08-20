{
  config,
  lib,
  pkgs,
  ...
}: {
  # 当前 nixpkgs 25.11 中 docker_28 已标记 insecure；暂按旧行为显式允许。
  nixpkgs.config.permittedInsecurePackages = ["docker-28.5.2"];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "journald";
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
