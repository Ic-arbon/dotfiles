{
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forAllSystems = nixpkgs.lib.genAttrs systems;

  genSpecialArgs = system: {
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      # overlays = [ inputs.nur.overlays.default ];
    };
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      # overlays = [ inputs.nur.overlays.default ];
    };

    nix-gaming = inputs.nix-gaming.packages.${system};
  };
in {
  inherit forAllSystems genSpecialArgs;

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  overlays = import ../overlays {inherit inputs;};
  homeManagerModules = import ../modules;

  # pre-commit：格式化 + 密钥/私钥泄漏防护。
  # 安装：nix develop --command pre-commit install
  preCommitChecks = forAllSystems (system:
    inputs.pre-commit-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        alejandra.enable = true;
        check-added-large-files.enable = true;
        detect-private-keys.enable = true;
        gitleaks = {
          enable = true;
          entry = "${nixpkgs.legacyPackages.${system}.gitleaks}/bin/gitleaks protect --staged --no-banner --redact=100";
          pass_filenames = false;
        };
        no-plaintext-secrets = {
          enable = true;
          entry = "${../scripts/check-no-plaintext-secrets.sh}";
          files = "^secrets/";
          pass_filenames = false;
        };
      };
    });

  pkgArgs = forAllSystems genSpecialArgs;
}
