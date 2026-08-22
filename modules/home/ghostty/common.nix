{
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # 固定字号，避免 Stylix 在 macOS 上放大到 21.33pt。
      font-size = lib.mkForce 16;
    };
  };
}
