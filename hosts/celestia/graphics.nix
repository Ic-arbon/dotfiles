{
  config,
  lib,
  pkgs,
  ...
}: {
  # https://wiki.hyprland.org/Nvidia/
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true; # RTX 5000 系列 (Blackwell) 必须使用开源内核模块
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    modesetting.enable = true;
    powerManagement.enable = true;

    prime = {
      sync.enable = true;

      # celestia: NVIDIA pci@0000:02:00.0, Intel pci@0000:00:02.0
      nvidiaBusId = "PCI:2:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
