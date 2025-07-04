{ inputs, config, pkgs, pkgs-unstable, ... }:
{
  # programs.ranger = {
  #   enable = true;
  # };
  # xdg.configFile."ranger/rifle.conf".source = ./rifle.conf;

  programs.lf = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableZshIntegration = true;
    shellWrapperName = "y";
    
    plugins = {
       smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
       chmod = "${inputs.yazi-plugins}/chmod.yazi";
       full-border = "${inputs.yazi-plugins}/full-border.yazi";
       git = "${inputs.yazi-plugins}/git.yazi";
       mount = "${inputs.yazi-plugins}/mount.yazi";
    };

    settings = {
      plugin.prepend_fetchers = [
        {
          id   = "git";
          name = "*";
          run  = "git";
        }
        {
          id   = "git";
          name = "*/";
          run  = "git";
        }
      ];
    };
    
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter directory or open file";
        }
        {
          on = "<Right>";
          run = "plugin smart-enter";
          desc = "Enter directory or open file";
        }
        {
          on = [ "c" "m" ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on  = "M";
          run = "plugin mount";
        }
      ];
    };
    
    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
    '';
  };

  home.packages = with pkgs; [
    udisks
  ];

  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {

    };
    associations.added = {
      "video/*" = [ "vlc.desktop" ];
    };
    associations.removed = {
      "image/webp" = [ "gimp.desktop" ];
    };
  };

}
