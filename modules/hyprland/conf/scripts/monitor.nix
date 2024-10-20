{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "external-monitor-detector";
  runtimeInputs = with pkgs; [ socat ];
  text = ''
    handle() {
      case $1 in
        monitoradded*) 
          echo "$1" > ~/aa
          hyprctl keyword monitor "eDP-1, disable" 
          ;;
        monitorremoved*) 
          # hyprctl keyword monitor "eDP-1, highres, 1920x0, auto" 
          ;;
      esac
    }
    
    socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
  '';
}
