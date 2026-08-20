# https://github.com/fufexan/dotfiles/blob/483680e/system/programs/steam.nix
{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils

          # fix CJK fonts
          source-sans
          source-serif
          source-han-sans
          source-han-serif

          # audio
          pipewire

          # other common
          udev
          alsa-lib
          vulkan-loader
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          wayland
        ];
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  hardware.xone.enable = true;

  fonts.packages = with pkgs; [
    wqy_zenhei
  ];
}
