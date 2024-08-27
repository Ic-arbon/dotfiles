{
  programs.ranger = {
    enable = true;
  };

  xdg.configFile."ranger/rifle.conf".source = ./rifle.conf;
}
