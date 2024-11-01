# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  astronvim = import ./astronvim.nix;
  bluetooth = import ./bluetooth.nix;
  # asus = import ./asus.nix;
  capture = import ./capture.nix;
  dae = import ./dae;
  electron = import ./electron.nix;
  fcitx5 = import ./fcitx5.nix;
  filemanager = import ./filemanager.nix;
  firefox = import ./firefox.nix;
  font = import ./font.nix;
  git = import ./git.nix;
  hyprland = import ./hyprland/hyprland.nix;
  shell = import ./shell.nix;
  ssh = import ./ssh.nix; # 不能全自动化部署，需要ssh-keygen -t ed25519，并上传公钥
  systemd = import ./systemd;
  # vivado = import ./vivado.nix;
  waybar = import ./hyprland/waybar.nix;
}
