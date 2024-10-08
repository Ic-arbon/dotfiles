{
  programs.ranger = {
    enable = true;
  };

  programs.lf = {
    enable = true;
  };

  xdg.configFile."ranger/rifle.conf".source = ./rifle.conf;
}
