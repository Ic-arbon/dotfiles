{pkgs, ...}: {
  programs.git = {
    enable = true;
    #  TODO: REPLACE with your username and email
    userName = "Ic-arbon";
    userEmail = "dty2015@hotmail.com";
    # aliases = {
    #   st = "status";
    # };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.git-credential-oauth = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      gs = "git status -s";
      gst = "git status";
      ga = "git add";
      gc = "git commit";
      gsw = "git switch";
    };
  };

  home.file = {
    ".gitconfig" = {
      text = ''
         [credential]
        helper = cache --timeout 21600	# six hours
        helper = oauth -device
      '';
    };
  };
}
