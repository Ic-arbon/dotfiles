# 入口：无条件导入 common + 两个平台文件，
# 平台文件内部用 mkIf 按 pkgs.stdenv 决定是否生效。
{
  imports = [
    ./common.nix
    ./darwin.nix
    ./linux.nix
  ];
}
