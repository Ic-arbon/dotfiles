{
  description = "Ic-arbon's nix configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager-stable = {
    #   url = "github:nix-community/home-manager/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # nix-darwin for macOS support
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      # url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR
    nur.url = "github:nix-community/NUR";

    # sops-nix for encrypted secrets in repo
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixGL
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    stylix = {
      # url = "github:nix-community/stylix/release-24.11";
      url = "github:nix-community/stylix/release-25.11";
      # url = "github:nix-community/stylix";
    };

    # community wayland nixpkgs
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # anyrun - a wayland launcher
    # anyrun = {
    #   url = "github:Kirottu/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Gaming on Nix
    nix-gaming.url = "github:fufexan/nix-gaming";
    # umu = {
    #   url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";

    # yazi plugins
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  # TODO: add "trusted-users = user_name" to /etc/nix/nix.conf
  nixConfig = {
    # 使用 substituters（覆盖式）让国内镜像真正优先于官方 cache
    # 查询顺序：从上到下依次尝试，命中即止
    substituters = [
      # 国内镜像优先（SJTU 代理了官方 cache，大部分包在这里就能拿到）
      "https://mirror.sjtu.edu.cn/nix-channels/store"

      # 第三方 cache
      "https://yazi.cachix.org"
      # "https://anyrun.cachix.org"
      # "https://nix-gaming.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
      # "https://hyprland.cachix.org"
      # "https://cache.garnix.io"  # dae for linux

      # 官方 cache 兜底（SJTU 镜像没覆盖的包 fallback 到这里）
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="

      # dae
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
