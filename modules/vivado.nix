{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: You should manually download the pkg
    (config.lib.nixGL.wrap pkgs.nur.repos.lschuermann.vivado-2020_1)
  ];

  home.sessionVariables = {
    # fix blank UI in WM
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };
}
