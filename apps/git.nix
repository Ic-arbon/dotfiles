{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "Ic-arbon";
      userEmail = "dty2015@hotmail.com";
    };

    lazygit = {
      enable = true;
    };

    git-credential-oauth = {
      enable = true;
    };
  };
}
