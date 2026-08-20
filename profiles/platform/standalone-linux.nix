# 独立 home-manager 部署（Fedora / Arch / SteamOS 等非 NixOS Linux）。
# 由 builders 根据 identity.kind == "standalone" 自动注入。
{lib, ...}: {
  targets.genericLinux.enable = true;
}
