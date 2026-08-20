# 蓝牙 + 外设基线；更细的触摸板参数可放 hosts 私有模块。
{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  services.libinput.enable = true;
}
