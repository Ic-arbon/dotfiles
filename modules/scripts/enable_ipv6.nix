{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "enable_ipv6";
  runtimeInputs = with pkgs; [ ];
  text = ''
    sysctl -w net.ipv6.conf.all.disable_ipv6=0
    sysctl -w net.ipv6.conf.default.disable_ipv6=0
  '';
}
