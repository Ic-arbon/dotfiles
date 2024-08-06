{pkgs, ...}: {
  programs.git = {
    enable = true;
    #  TODO: REPLACE with your username and email
    userName = "Ic-arbon";
    userEmail = "dty2015@hotmail.com";
  };

  programs.lazygit = {
    enable = true;
  };

  programs.git-credential-oauth = {
    enable = true;
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
