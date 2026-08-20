# 三类部署形态的统一 builder。
# machines/<username>@<hostname>.nix 只提供声明式 spec，
# 这里负责 nixosSystem / darwinSystem / homeManagerConfiguration 的所有样板。
{
  inputs,
  common,
  profiles,
  outputs,
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin;
  lib = nixpkgs.lib;

  metaModule = ../modules/meta.nix;

  # 秘密管理 v2：拆分 common（所有机器共享）与 host（机器专属）两个 sops 文件。
  # 任一文件存在时启用 sops-nix，否则回退到仓库外明文模式。
  commonSopsFile = ../secrets/common/secrets.yaml;

  hostSopsFile = spec:
    ../secrets/hosts + "/${spec.identity.username}@${spec.identity.hostname}/secrets.yaml";

  homeDirFor = spec:
    spec.home.homeDirectory
      or (
      if spec.identity.kind == "darwin"
      then "/Users/${spec.identity.username}"
      else "/home/${spec.identity.username}"
    );

  # 把机器 spec 的 identity/facts 注入 dotfiles.* options（系统与 HM 共用）
  dotfilesOptions = spec: let
    hostFile = hostSopsFile spec;
    commonExists = builtins.pathExists commonSopsFile;
    hostExists = builtins.pathExists hostFile;
  in {
    dotfiles.machine = {
      identity = "${spec.identity.username}@${spec.identity.hostname}";
      username = spec.identity.username;
      hostname = spec.identity.hostname;
      system = spec.identity.system;
      kind = spec.identity.kind;
    };
    dotfiles.hardware = {
      laptop = spec.facts.laptop or false;
      nvidia = spec.facts.nvidia or false;
    };
    dotfiles.desktop.monitor = spec.facts.monitor or ",preferred,auto,auto";
    dotfiles.secretsDir =
      spec.home.secretsDir
        or (
        if spec.identity.kind == "darwin"
        then "/Users/${spec.identity.username}/.config/dotfiles/secrets"
        else "/home/${spec.identity.username}/.config/dotfiles/secrets"
      );
    dotfiles.secrets.commonFile =
      if commonExists
      then commonSopsFile
      else null;
    dotfiles.secrets.hostFile =
      if hostExists
      then hostFile
      else null;
    dotfiles.sops.enable = commonExists || hostExists;
  };

  # 系统级 sops（NixOS/darwin activation，root 上下文）用机器 host key。
  systemSopsOptions = spec: let
    hostFile = hostSopsFile spec;
    commonExists = builtins.pathExists commonSopsFile;
    hostExists = builtins.pathExists hostFile;
  in {
    sops = lib.mkIf (commonExists || hostExists) {
      defaultSopsFile =
        if commonExists
        then commonSopsFile
        else hostFile;
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };

  # 用户级 sops（home-manager activation）用用户 SSH key；
  # 可选的 home.sopsAgeKeyFile 用于 passphrase-protected SSH key 的场景。
  userSopsOptions = spec: let
    hostFile = hostSopsFile spec;
    commonExists = builtins.pathExists commonSopsFile;
    hostExists = builtins.pathExists hostFile;
    userSshKey = "${homeDirFor spec}/.ssh/id_ed25519";
  in {
    sops = lib.mkIf (commonExists || hostExists) (
      {
        defaultSopsFile =
          if commonExists
          then commonSopsFile
          else hostFile;
        age.sshKeyPaths = [userSshKey];
      }
      // lib.optionalAttrs ((spec.home.sopsAgeKeyFile or null) != null) {
        age.keyFile = spec.home.sopsAgeKeyFile;
      }
    );
  };

  systemOptions = spec:
    (dotfilesOptions spec)
    // (systemSopsOptions spec);

  userOptions = spec:
    (dotfilesOptions spec)
    // (userSopsOptions spec);

  homeSettings = spec: {
    home.username = spec.identity.username;
    home.homeDirectory = homeDirFor spec;
    home.stateVersion = spec.home.stateVersion;
  };

  autoHomeProfiles = spec:
    [profiles.home.core]
    ++ lib.optionals (spec.identity.kind == "standalone") [
      profiles.home.platform.standalone
    ];

  userModules = spec:
    [
      metaModule
      (userOptions spec)
      (homeSettings spec)
      (../users/${spec.identity.username}/common.nix)
    ]
    ++ lib.flatten (autoHomeProfiles spec)
    ++ lib.flatten (spec.profiles.home or [])
    ++ (spec.home.extraImports or []);

  sharedHomeModules = spec:
    [
      inputs.stylix.homeModules.stylix
      inputs.sops-nix.homeManagerModules.sops
    ]
    ++ lib.optionals (!(spec.home.useGlobalPkgs or false)) [
      {
        nixpkgs.overlays = [inputs.nur.overlays.default];
        nixpkgs.config.allowUnfree = true;
      }
    ];

  pkgArgsFor = system: common.pkgArgs.${system} // {inherit inputs outputs;};

  mkNixOS = spec: let
    system = spec.identity.system;
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = pkgArgsFor system;
      modules =
        [
          metaModule
          (systemOptions spec)
          inputs.sops-nix.nixosModules.sops
        ]
        ++ (spec.system.extraImports or [])
        ++ lib.flatten (spec.profiles.system or [])
        ++ lib.optional (spec.system.dae or false) inputs.daeuniverse.nixosModules.dae
        ++ lib.optional (spec.system.daed or false) inputs.daeuniverse.nixosModules.daed
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = spec.home.useGlobalPkgs or false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = pkgArgsFor system;
            home-manager.users.${spec.identity.username} = {
              imports = userModules spec;
            };
            home-manager.sharedModules = sharedHomeModules spec;
          }
          {
            nixpkgs.overlays = lib.mkIf (spec.system.nur or false) [
              inputs.nur.overlays.default
            ];
            nixpkgs.config.allowUnfree = true;
          }
        ];
    };

  mkDarwin = spec: let
    system = spec.identity.system;
  in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = pkgArgsFor system;
      modules =
        [
          metaModule
          (systemOptions spec)
          inputs.sops-nix.darwinModules.sops
        ]
        ++ (spec.system.extraImports or [])
        ++ lib.flatten (spec.profiles.system or [])
        ++ [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = spec.home.useGlobalPkgs or false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = pkgArgsFor system;
            home-manager.users.${spec.identity.username} = {
              imports = userModules spec;
            };
            home-manager.sharedModules = sharedHomeModules spec;
          }
        ];
    };

  mkStandaloneHome = spec: let
    system = spec.identity.system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [inputs.nur.overlays.default];
    };
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = pkgArgsFor system;
      modules =
        userModules spec
        ++ sharedHomeModules spec;
    };
in {
  inherit mkNixOS mkDarwin mkStandaloneHome profiles;
}
