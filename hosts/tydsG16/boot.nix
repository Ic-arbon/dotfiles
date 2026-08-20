{pkgs-unstable, ...}: {
  # Zen 内核（桌面/游戏性能更好）
  boot.kernelPackages = pkgs-unstable.linuxPackages_zen;

  # 追加用户选择的内核模块（与 hardware-configuration.nix 的 kvm-intel 合并）
  boot.kernelModules = ["nvidia" "asus-nb-wmi"];

  # Intel CPU 嵌套虚拟化
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # 内核启动参数
  boot.kernelParams = [
    # 修复 brightnessctl 在 dGPU 模式下不工作
    # https://wiki.archlinux.org/title/Backlight#Kernel_command-line_options
    "acpi_backlight=native"

    # 深度睡眠（suspend-to-RAM 能耗更低）
    "mem_sleep_default=deep"

    # 休眠恢复设备
    "resume=/dev/disk/by-label/swap"
  ];

  # 休眠恢复（与 kernelParams 里的 resume= 配合）
  boot.resumeDevice = "/dev/disk/by-label/swap";

  # systemd-boot
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
