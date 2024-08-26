# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  astronvim = import ./astronvim.nix;
  asus = import ./asus.nix;
  fcitx5 = import ./fcitx5.nix;
  firefox = import ./firefox.nix;
  git = import ./git.nix;
  ranger = import ./ranger.nix;
  shell = import ./shell.nix;
  ssh = import ./ssh.nix; # 不能全自动化部署，需要ssh-keygen -t ed25519，并上传公钥
  obs = import ./obs.nix;
  vivado = import ./vivado.nix;
  # lang = import ./lang.nix;
}
