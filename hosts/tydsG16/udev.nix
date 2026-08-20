# G16 专属 udev 规则：PCIe 端口禁止唤醒 + 有线网卡 WoL。
# probe-rs 等嵌入式调试规则在 profiles.system.embedded-hardware。
{pkgs, ...}: {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol g"
  '';
}
