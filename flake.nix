{
  description = "Ic-arbon's nix configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager-stable = {
    #   url = "github:nix-community/home-manager/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # NUR
    nur.url = "github:nix-community/NUR";

    # nixGL
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # community wayland nixpkgs
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # anyrun - a wayland launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Gaming on Nix
    nix-gaming.url = "github:fufexan/nix-gaming";
    
    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";
  };

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  # TODO: add "trusted-users = user_name" to /etc/nix/nix.conf
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://nix-gaming.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"

      # dae for linux
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="

      # dae
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
