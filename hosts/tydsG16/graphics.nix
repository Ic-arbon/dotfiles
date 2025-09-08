{ config, lib, pkgs, ... }:
{
  # https://wiki.hyprland.org/Nvidia/
  boot.kernelParams = [
    # fix suspend and hibernate
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # "nvidia-drm.fbdev=1"
  ];
  
  hardware.brillo.enable = true;
  services.xserver.videoDrivers = ["nvidia"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = false;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    # Fix XID:119
    gsp.enable = false;

    # required by most wayland compositors!
    modesetting.enable = true;
    powerManagement.enable = true;

    prime = {
      sync.enable = true;

	    # Make sure to use the correct Bus ID values for your system!
	    # sudo lshw -c display => start from first ":" => hex to dec
	    nvidiaBusId = "PCI:1:0:0";
	    intelBusId = "PCI:0:2:0";
        # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };

  };

  hardware.nvidia-container-toolkit.enable = true;

  # OpenGL
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
  };

  # disable cudasupport before this issue get fixed:
  # https://github.com/NixOS/nixpkgs/issues/338315
  # nixpkgs.config.cudaSupport = true;

}
