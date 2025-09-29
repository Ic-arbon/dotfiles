{ inputs, config, lib, pkgs, pkgs-stable, ...}:
let
  # 直接进行环境检测，避免循环依赖
  isNixOS = builtins.pathExists /etc/nixos;
  isArchLinux = builtins.pathExists /etc/arch-release;
  isLaptop = builtins.pathExists "/sys/class/power_supply/BAT0" ||
             builtins.pathExists "/sys/class/power_supply/BAT1";
  hasNvidia = builtins.pathExists "/dev/nvidia0" ||
              builtins.pathExists "/proc/driver/nvidia";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkDefault (
      if isNixOS
      # 在NixOS上使用来自inputs的hyprland
      # then inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      then pkgs.hyprland
      # 在非NixOS（如ArchLinux）上使用nixGL包装的hyprland
      else (config.lib.nixGL.wrap pkgs-stable.hyprland)
    );
    # 根据环境选择portal包
    portalPackage = if isNixOS 
      then inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      else pkgs-stable.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
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
      # "disable_logs" = "false";
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
      # 外接显示器配置
      # "HDMI-A-1,preferred,0x0,1"
      # 根据环境和设备类型配置内置显示器
      (
        if !isLaptop then
          # 服务器通常不需要显示器配置
          ",preferred,auto,auto"
        else if isNixOS then
          # NixOS笔记本（通常是eDP-2）
          "eDP-1,preferred,auto,auto"
          # "eDP-2,disable"  # 当有外接显示器时禁用内置显示器
        else
          # ArchLinux笔记本（通常是eDP-1）
          "eDP-1,highres,auto,auto"
      )
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
      "waybar &"
      "fcitx5 -d &"
      # "fcitx5-remote -r"
      # "fcitx5 -d --replace &"
      # "fcitx5-remote -r"
    ];

    # exec = [
    #   "gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-macchiato-mauve-compact'"   # for GTK3 apps
    #   "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"   # for GTK4 apps
    # ];


    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hyprland.org/Configuring/Environment-variables/
    env = [
      "XDG_SESSION_TYPE,wayland"

      # fix https://github.com/hyprwm/Hyprland/issues/1520
      "WLR_NO_HARDWARE_CURSORS,1"
      # 启用Ozone Wayland支持，在任何hyprland启用的情况下都设置
      "NIXOS_OZONE_WL,1"
    ] ++ lib.optionals hasNvidia [
      # NVIDIA相关环境变量
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "GBM_BACKEND,nvidia-drm"
    ];

    cursor = {
      "no_hardware_cursors" = "true";
    };

    input = {
      # "repeat_rate" = "0";
      # touchpad = {
      #   "disable_while_typing" = "false";
      # }
    };

    #####################
    ### LOOK AND FEEL ###
    #####################
    
    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    #-- General ----------------------------------------------------
    # General settings like MOD key, Gaps, Colors, etc.
    general = lib.mkForce({
      "gaps_in"="5";
      "gaps_out"="10";
    
      "border_size"="3";
      "col.active_border"="0xAA83A589";
      "col.inactive_border"="0xFF343A40";
    });
    
    #-- Decoration ----------------------------------------------------
    # Decoration settings like Rounded Corners, Opacity, Blur, etc.
    decoration = {
        "rounding"="8";       # Original: rounding=-1
    
        "active_opacity"="0.98";
        "inactive_opacity"="0.9";
        "fullscreen_opacity"="1.0";
    
        blur = {
            "enabled"="true";
            "size"="3";                	# minimum 1
            "passes"="1";               # minimum 1, more passes = more resource intensive.
            "ignore_opacity"="false";
        };

        shadow = {
          "enabled" = "false";
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
    misc = lib.mkDefault({
      "force_default_wallpaper" = "0"; # Set to 0 or 1 to disable the anime mascot wallpapers
      "disable_hyprland_logo" = "true"; # If true disables the random hyprland logo / anime girl background. :(
    });


    ###################
    ### KEYBINDINGS ###
    ###################
    
    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, P, exec, $menu"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating"
      "$mainMod SHIFT, F, fullscreen"
      "$mainMod, S, togglesplit"
      "$mainMod SHIFT, RETURN, exec, $terminal"
      "$mainMod SHIFT, C, killactive"
      "$mainMod SHIFT, Q, exit"
      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, h"
      "$mainMod, right, movefocus, l"
      "$mainMod, up, movefocus, k"
      "$mainMod, down, movefocus, j"

      "$mainMod, space, execr, fcitx5-remote -t"

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
      # ", switch:on:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, highres, auto, auto'"
      # trigger when the switch is turning off
      # ", switch:off:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, disable'"
    ];

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################
    
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
    
    windowrulev2 = [
      "fullscreen, class:Waydroid"
      "suppressevent maximize, class:.*"
    ];
    # "windowrulev2" = "suppressevent maximize, class:.*"; # You'll probably like this.
  };

  ### Utilities ###

  home.packages = with pkgs; [
    # scripts
    (import ./conf/scripts/monitor.nix {inherit pkgs;})

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

    slurp
    wl-clipboard 
    hyprshot
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
      #     "hyprland"
      #     "gtk"
      #   ];
      # };

    };

    # 添加额外的 portal 后端
    extraPortals = with pkgs-stable; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland
    ];
  };

  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs-stable.kitty);
    # settings = {
    #   background_opacity = "0.9";
    # };
    themeFile = "GruvboxMaterialDarkHard";
    # font.name = "FiraCode Nerd Font";
    # font.size = 16;
  };

  home.sessionVariables = {
    # Optional, hint Electron apps to use Wayland:
    NIXOS_OZONE_WL = "1";

    # Optional, hint fcitx to use waylandFrontend:
    GTK_IM_MODULE = lib.mkForce "";

    # GTK_IM_MODULE= "fcitx";
    # QT_IM_MODULES= "wayland;fcitx;ibus";
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
