# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  astronvim = import ./astronvim.nix;
  base-tools = import ./base-tools;
  # bluetooth = import ./bluetooth.nix;
  # asus = import ./asus.nix;
  # capture = import ./capture.nix;
  dae = import ./dae;
  embedded = import ./dev-tools/embedded;
  # electron = import ./electron.nix;
  # fcitx5 = import ./fcitx5.nix;
  filemanager = import ./filemanager.nix;
  # browsers = import ./browsers.nix;
  # font = import ./font.nix;
  # gaming = import ./gaming.nix;
  git = import ./git.nix;
  # hyprland = import ./hyprland/hyprland.nix;
  # maa = import ./maa.nix;
  shell = import ./shell.nix;
  ssh = import ./ssh.nix; # 不能全自动化部署，需要ssh-keygen -t ed25519，并上传公钥
  systemd = import ./systemd;
  # theme = import ./hyprland/theme.nix;
  # vivado = import ./vivado.nix;
  # waybar = import ./hyprland/waybar.nix;
}
