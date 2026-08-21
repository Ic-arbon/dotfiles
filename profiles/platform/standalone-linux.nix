# 独立 home-manager 部署（Fedora / Arch / SteamOS 等非 NixOS Linux）。
# 由 builders 根据 identity.kind == "standalone" 自动注入。
#
# 非 NixOS 的 GPU 方案统一使用 Home Manager 的 targets.genericLinux.gpu：
# - 不再使用 nixGL 逐包 wrap；
# - 首次 switch 后需要按提示执行一次 sudo 安装 /run/opengl-driver。
# 详细操作见 docs/gpu-non-nixos.md。
{lib, ...}: {
  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = true;
}
