{ pkgs, ... }:
{
  home.packages = with pkgs; [
    steam
    protonplus
    mangohud

    steamtinkerlaunch
    ### steamtinkerlaunch dependencies:
    bash 	# Only shell tested.
    git 	
    gnumake 	# Required for manual root installation with make only.
    unzip 	
    wget 	
    xdotool 	
    xorg.xprop 	
    xorg.xrandr 	
    xorg.xwininfo 	
    xxd 	# Part of vim.
    # GUI toolkit. Version 7.2 or higher required (see #98).
    # As well as system-wide installs, SteamTinkerLaunch also supports Custom Yad installs and the Yad AppImage.
    yad 	
  ];
}

