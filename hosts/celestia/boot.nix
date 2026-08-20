{pkgs-unstable, ...}: {
  # Zen 内核（桌面性能更好）
  boot.kernelPackages = pkgs-unstable.linuxPackages_zen;

  # 追加 nvidia 模块（与 hardware-configuration.nix 的 kvm-intel 合并）
  boot.kernelModules = ["nvidia"];

  # Intel CPU 嵌套虚拟化
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # systemd-boot + Windows 11 双系统
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
    windows = {
      "nvme0n1p1" = {
        title = "Windows 11";
        efiDeviceHandle = "FS0";
      };
    };
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
}
