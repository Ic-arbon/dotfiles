# 独立 home-manager 部署（Fedora / Arch / SteamOS 等非 NixOS Linux）。
# 由 builders 根据 identity.kind == "standalone" 自动注入。
{
  config,
  lib,
  ...
}: {
  targets.genericLinux.enable = true;

  # Nix 提供的 npm 不能写入只读的 /nix/store，
  # 统一把全局前缀指到用户目录，并把这个 bin 加入 PATH。
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.local
  '';
  home.sessionPath = ["${config.home.homeDirectory}/.local/bin"];
}
