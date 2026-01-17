{pkgs, pkgs-stable, ...}: {
  programs.git = {
    enable = true;
    #  TODO: REPLACE with your username and email
    settings.user.name = "Ic-arbon";
    settings.user.email = "dty2015@hotmail.com";
    # aliases = {
    #   st = "status";
    # };

    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      ".Trashes"
      "._* "

      # Editor/IDE specific
      "*.swp"
      "*.swo"
      "*.bak"
      "*.tmp"
      "*.local"
      "*.orig"

      # Python
      "__pycache__/"
      "*.pyc"

      # Nix
      "result"
      "result-*"
      ".direnv/"
    ];

    lfs = {
      enable = true;
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.git-credential-oauth = {
    enable = true;
    package = pkgs-stable.git-credential-oauth;
    extraFlags = [ "-device" ];
  };

  home.packages = with pkgs; [
    commitizen
    # python312Packages.argcomplete
  ];

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
    # initExtra = ''
    #   register-python-argcomplete cz
    # '';
  };

  # home.file = {
  #   ".gitconfig" = {
  #     text = ''
  #        [credential]
  #       helper = cache --timeout 21600	# six hours
  #       helper = oauth -device
  #     '';
  #   };
  # };
}
