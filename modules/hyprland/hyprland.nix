{ inputs, config, lib, pkgs, ...}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = config.lib.nixGL.wrap pkgs.hyprland;  # fix non-nixos crash
    xwayland.enable = true;
    systemd.variables = ["--all"];
  };

  wayland.windowManager.hyprland.plugins = [
    # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    # "/absolute/path/to/plugin.so"
  ];

  # hyprland configs, based on https://github.com/notwidow/hyprland
  xdg.configFile = {
    "hypr/scripts" = {
      source = ./conf/scripts;
      recursive = true;
    };
    # "hypr/waybar" = {
    #   source = ../conf/waybar;
    #   recursive = true;
    # };
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
      # "eDP-1,disable"
      "HDMI-A-1,preferred,auto,auto"
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
      "~/.config/hypr/scripts/startup"
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

      # MultiGPU, priority: nvidia > intel
      # TODO: Replace with ones own card
      # "AQ_DRM_DEVICES,/dev/dri/by-path/pci-0000:01:00.0-card:/dev/dri/by-path/pci-0000:00:02.0-card"

      # toolkit-specific scale
      "GDK_SCALE,2"
      "XCURSOR_SIZE,16"
    ];

    cursor = {
      "no_hardware_cursors" = "true";
    };

    input = {
      "repeat_rate" = "0";
      touchpad = {
        # "disable_while_typing" = "false";
      };
    };

    #####################
    ### LOOK AND FEEL ###
    #####################
    
    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    #-- General ----------------------------------------------------
    # General settings like MOD key, Gaps, Colors, etc.
    general = {
        "gaps_in"="5";
        "gaps_out"="10";
    
        "border_size"="3";
        "col.active_border"="0xAA83A589";
        "col.inactive_border"="0xFF343A40";
    };
    
    #-- Decoration ----------------------------------------------------
    # Decoration settings like Rounded Corners, Opacity, Blur, etc.
    decoration = {
        "rounding"="8";       # Original: rounding=-1
        "drop_shadow"="false";
    
        "active_opacity"="0.98";
        "inactive_opacity"="0.9";
        "fullscreen_opacity"="1.0";
    
        blur = {
            "enabled"="true";
            "size"="3";                	# minimum 1
            "passes"="1";               # minimum 1, more passes = more resource intensive.
            "ignore_opacity"="false";
        };
    
        # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
        # if you want heavy blur, you need to up the blur_passes.
        # the more passes, the more you can up the blur_size without noticing artifacts.
    };
    
    #-- Animations ----------------------------------------------------
    animations = {
      "enabled"="1";
      # "animation"="NAME,ONOFF,SPEED,CURVE,STYLE";
      animation= [
        "windows,1,8,default,popin 80%"
        "fadeOut,1,8,default"
        "fadeIn,1,8,default"
        "workspaces,1,8,default"
        #"animation"="workspaces,1,6,overshot"
      ];
    };
    
    #-- Dwindle ----------------------------------------------------
    dwindle = {
        "pseudotile"="0"; 			# enable pseudotiling on dwindle
    };
    
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

      # Screenshots
      # ", Print, exec, grimblast copy area"
      ",Print,exec,XDG_CURRENT_DESKTOP=sway flameshot gui --raw -p ~/Pictures/Screenshots | wl-copy"
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
    bindel = [
      # backlight
      ",XF86MonBrightnessUp,exec,brightnessctl set +5% "
      ",XF86MonBrightnessDown,exec,brightnessctl set 5%- "

      # volume
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
    bindl = [
      # volume mute
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # trigger when the switch is turning on
      ", switch:on:[switch name], exec, hyprctl keyword monitor 'eDP-1, disable'"
      # trigger when the switch is turning off
      ", switch:off:[switch name], exec, hyprctl keyword monitor 'eDP-1, highres, auto, auto'"
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
    # for gtk apps
    dconf

    # QT support 
    libsForQt5.qt5.qtwayland  # qt5
    kdePackages.qtwayland     # qt6

    # backlight
    brightnessctl
    # wpctl
    wireplumber

    # notification daemon
    dunst
    libnotify

    # utils for monitor listening script
    socat

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

  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";
    # themeFile = "gruvbox-dark-hard";
    font.name = "FiraCode Nerd Font";
    font.size = 16;
  };

  ## Optional ##
  systemd.user.enable = true;

  home.sessionVariables = {
    # Optional, hint Electron apps to use Wayland:
    # NIXOS_OZONE_WL = "1";
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
}
