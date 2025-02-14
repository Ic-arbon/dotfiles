[
  {
    # output = [ "DP-1" "eDP-2" ];
    # output = [ "eDP-1" "HDMI-A-1" ];
    height = 34;
    spacing = 4;
    modules-left = [
      "hyprland/workspaces"
      "cava"
      "hyprland/submap"
      "sway/scratchpad"
    ];
    modules-center = [ "hyprland/window" ];
    modules-right = [
      "mpris"
      "idle_inhibitor"
      # "load"
      # "cpu"
      # "memory"
      # "bluetooth"
      # "pulseaudio"
      "wireplumber"
      "backlight"
      "clock"
      "battery"
      "tray"
    ];
    "hyprland/workspaces" = {
      all-outputs = true;
      warp-on-scroll = false;
      enable-bar-scroll = true;
      disable-scroll-wraparound = true;
      format = "{icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "";
        "7" = "";
      };
    };
    "hyprland/window" = {
      format = "{title}";
      max-length = 40;
      all-outputs = true;
    };
    cava = {
      framerate = 30;
      autosens = 1;
      bars = 14;
      lower_cutoff_freq = 50;
      higher_cutoff_freq = 10000;
      method = "pipewire";
      source = "auto";
      stereo = true;
      bar_delimiter = 0;
      noise_reduction = 0.77;
      input_delay = 2;
      hide_on_silence = true;
      format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      actions = { on-click-right = "mode"; };
    };
    mpris = {
      format = " {status_icon} {dynamic}";
      interval = 1;
      dynamic-len = 40;
      status-icons = {
        playing = "▶";
        paused = "⏸";
        stopped = "";
      };
      dynamic-order = [ "title" "artist" ];
      ignored-players = [ "firefox" "chromium" ];
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = { activated = ""; deactivated = ""; };
    };
    "hyprland/submap" = { format = "{}"; };
    "sway/scratchpad" = {
      format = "{icon} {count}";
      show-empty = false;
      format-icons = [ "" "" ];
      tooltip = true;
      tooltip-format = "{app}: {title}";
    };
    # 托盘
    tray = { icon-size = 14; spacing = 10; };
    load = { format = " {}"; };
    cpu = { format = "{usage}% "; tooltip = false; };
    memory = { format = "{}% "; };
    temperature = {
      critical-threshold = 80;
      format = "{temperatureC}°C {icon}";
      format-icons = [ "" "" "" ];
    };
    # pulseaudio = {
    #   format = "{icon} {volume}%";
    #   format-bluetooth = " {icon} {volume}%";
    #   format-muted = "";
    #   format-icons = {
    #     # "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
    #     # "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
    #     headphone = "";
    #     hands-free = "";
    #     headset = "";
    #     phone = "";
    #     phone-muted = "";
    #     portable = "";
    #     car = "";
    #     default = [ "" "" "" ];
    #   };
    #   scroll-step = 1;
    #   # on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    #   # on-click = "amixer set Master toggle";
    #   on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    #   on-click-right = "pavucontrol";
    #   ignored-sinks = [ "Easy Effects Sink" ];
    # };
    wireplumber = {
      scroll-step = 1;
      format = "{icon} {volume}%";
      # format-bluetooth = "{icon} {volume}% ";
      # format-bluetooth-muted = " {icon}";
      format-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" "" ];
      };
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      on-click-right = "pavucontrol";
    };
    backlight = {
      format = "{icon} {percent}%";
      format-icons = [ "" "" "" "" "" "" "" "" "" ];
    };
    clock = {
      interval = 1;
      timezone = "Asia/Shanghai";
      format = "{:%H:%M:%S}";
      tooltip-format = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
      format-alt = "{:%Y-%m-%d}";
    };
    battery = {
      interval = 6;
      states = { warning = 30; critical = 15; };
      format = "{icon} {capacity}%";
      format-full = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-alt = "{icon} {time}";
      format-icons = [ "" "" "" "" "" ];
    };
  }
  # {
  #   output = [ "HDMI-A-1" ];
  #   height = 24;
  #   spacing = 4;
  #   modules-left = [
  #     "hyprland/workspaces"
  #     "hyprland/submap"
  #     "sway/scratchpad"
  #   ];
  #   modules-center = [ "clock" ];
  #   modules-right = [ "sway/window" ];
  #   "hyprland/workspaces" = {
  #     all-outputs = true;
  #     warp-on-scroll = true;
  #     enable-bar-scroll = true;
  #     format = "{icon}";
  #     format-icons = {
  #       "1" = "";
  #       "2" = "";
  #       "3" = "";
  #       "4" = "";
  #       "5" = "";
  #       "9" = "";
  #       "10" = "";
  #     };
  #   };
  #   "sway/window" = {
  #     format = "{title}";
  #     max-length = 40;
  #     all-outputs = true;
  #   };
  #   "hyprland/submap" = { format = "{}"; };
  #   "sway/scratchpad" = {
  #     format = "{icon} {count}";
  #     show-empty = false;
  #     format-icons = [ "" "" ];
  #     tooltip = true;
  #     tooltip-format = "{app}: {title}";
  #   };
  #   clock = {
  #     tooltip-format = ''
  #       <big>{:%Y %B}</big>
  #       <tt><small>{calendar}</small></tt>'';
  #     format-alt = "{:%Y-%m-%d}";
  #   };
  # }
]
