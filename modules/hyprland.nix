{ inputs, config, lib, pkgs, ...}:
let
  starupScript = pkgs.writeShellScriptBin "initWallpaper" ''
    swww-daemon &
    sleep 1
    swww img $HOME/dotfiles/wallpapers/default.jpg &
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    systemd.variables = ["--all"];
  };

  wayland.windowManager.hyprland.plugins = [
    # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    # "/absolute/path/to/plugin.so"
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      # package = pkgs.gnome.adwaita-icon-theme;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  wayland.windowManager.hyprland.settings = {
    debug = {
      "disable_logs" = "false";
    };
    # unscale XWayland
    xwayland = {
      "force_zero_scaling" = "true";
    };

    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      # ",preferred,auto,auto"

      # change monitor to high resolution
      "eDP-1,highres,auto,auto"
    ];

    ###################
    ### MY PROGRAMS ###
    ###################

    # See https://wiki.hyprland.org/Configuring/Keywords/

    # Set programs that you use
    "$terminal" = "kitty";
    "$fileManager" = "thunar";
    "$menu" = "rofi -show drun -show-icons";

    #################
    ### AUTOSTART ###
    #################
    
    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:
    
    exec-once = [
      "${starupScript}/bin/initWallpaper"
      # "waybar &"
    ];

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hyprland.org/Configuring/Environment-variables/
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"

      # "WLR_DRM_DEVICES,/dev/dri/card0"

      # toolkit-specific scale
      "GDK_SCALE,2"
      "XCURSOR_SIZE,32"
    ];

    cursor = {
      "no_hardware_cursors" = "true";
    };

    #####################
    ### LOOK AND FEEL ###
    #####################
    
    # Refer to https://wiki.hyprland.org/Configuring/Variables/
    
    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      "force_default_wallpaper" = "0"; # Set to 0 or 1 to disable the anime mascot wallpapers
      "disable_hyprland_logo" = "true"; # If true disables the random hyprland logo / anime girl background. :(
    };


    ###################
    ### KEYBINDINGS ###
    ###################
    
    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, P, exec, $menu"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating"
      "$mainMod, S, togglesplit"
      "$mainMod SHIFT, RETURN, exec, $terminal"
      "$mainMod SHIFT, C, killactive"
      "$mainMod SHIFT, Q, exit"
      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, h"
      "$mainMod, right, movefocus, l"
      "$mainMod, up, movefocus, k"
      "$mainMod, down, movefocus, j"
      ", Print, exec, grimblast copy area"
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mainMod, code:1${toString i}, workspace, ${toString ws}"
            "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
    );
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow" 
    ];

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################
    
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    "windowrulev2" = "suppressevent maximize, class:.*"; # You'll probably like this.
  };

  ### Utilities ###

  home.packages = with pkgs; [
    # 在 home.packages 中确保安装了xdp后端
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-hyprland

    # for gtk apps
    dconf

    # QT support 
    libsForQt5.qt5.qtwayland  # qt5
    kdePackages.qtwayland     # qt6

    # notification daemon
    dunst
    libnotify

    # wallpaper
    swww

    # fileManager
    xfce.thunar
  ];

  ## MUST HAVE ##

  # 启用 xdg-desktop-portal 服务
  xdg.portal = {
    enable = true;

    config = {
      # 为所有接口设置默认的 portal 实现为所有可用的实现
      common.default = "*";
      # common = {
      #   default = [
      #     "gtk"
      #   ];
      # };

    };

    # 添加 xdg-desktop-portal-wlr 作为额外的 portal 后端
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings = import ./waybar.nix;
    style = ./style-waybar.css;
  };

  ## Optional ##
  systemd.user.enable = true;

  home.sessionVariables = {
    # Optional, hint Electron apps to use Wayland:
    NIXOS_OZONE_WL = "1";
  };

  # audio visualizer for waybar
  programs.cava = {
    enable = true;
  };
  services.playerctld.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

}
