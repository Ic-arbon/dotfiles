# Modular
我为什么不用中文写呢(哭
write your own module to config apps
import them in `default.nix` 
[搜索设置关键词：pkgname home-manager](https://mynixos.com/)

### Standard
```nix
# example.nix
{config, pkgs, libs...}:
{
  # install pkgs with configurations
  programs.example = {
    enable = true;
    # optional configurations
    # example_option = type_of_value;
  };
  
  # install pkgs without configurations
  home.packages = with pkgs; [
    hello
    steam
  ];
  
  # make symlink or copy from $HOME/target to source
  home.file = {
    "home-manager" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles"
      recursive = true;
    };
  };
  
  # make symlink or copy from $XDG_CONFIG_HOME/target to source
  xdg.configFile = {

  };
}
```
