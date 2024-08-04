{ pkgs, ... }:

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
