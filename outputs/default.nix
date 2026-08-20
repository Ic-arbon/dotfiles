inputs: let
  common = import ./common.nix inputs;
  profileCatalog = import ../profiles {hmModules = common.homeManagerModules;};
  lib = inputs.nixpkgs.lib;

  # 扫描 machines/ 下所有 <username>@<hostname>.nix。
  # 文件本身就是唯一注册点：新增机器只加文件，不用改这里。
  machineFiles =
    builtins.attrNames
    (lib.filterAttrs
      (
        name: type:
          type
          == "regular"
          && lib.hasSuffix ".nix" name
          && (builtins.match "^[^@]+@[^@]+\.nix$" name) != null
      )
      (builtins.readDir ../machines));

  readMachine = fileName: let
    base = lib.removeSuffix ".nix" fileName;
    parts = lib.splitString "@" base;
    username = builtins.elemAt parts 0;
    hostname = builtins.elemAt parts 1;
    identity = "${username}@${hostname}";
    spec = import (../machines + "/${fileName}") {
      inherit inputs;
      profiles = profileCatalog;
    };
    check =
      lib.assertMsg
      (
        spec.identity.username
        == username
        && spec.identity.hostname == hostname
      )
      "machines/${fileName}: 文件名必须是 <username>@<hostname>.nix 且与 identity 一致（当前是 ${identity}）";
    spec' = builtins.seq check spec;
  in {
    inherit fileName username hostname identity;
    spec = spec';
  };

  machines = map readMachine machineFiles;

  identities = map (m: m.identity) machines;
  uniqueIdentities = lib.unique identities;
  identityCheck =
    lib.assertMsg
    (lib.length identities == lib.length uniqueIdentities)
    "machines/ 中存在重复的 username@hostname 身份";

  byKind = kind:
    lib.filter (m: m.spec.identity.kind == kind) machines;

  outputs = rec {
    formatter = common.formatter;
    packages = common.forAllSystems (system: {
      inherit (inputs.nixpkgs.legacyPackages.${system}) age sops ssh-to-age;
    });
    overlays = common.overlays;
    homeManagerModules = common.homeManagerModules;
    profiles = profileCatalog;
    checks =
      lib.mapAttrs
      (system: check: {pre-commit-check = check;})
      common.preCommitChecks;

    nixosConfigurations = builtins.seq identityCheck (
      lib.listToAttrs
      (
        map
        (
          m:
            lib.nameValuePair m.spec.identity.hostname
            (builders.mkNixOS m.spec)
        )
        (byKind "nixos")
      )
    );

    darwinConfigurations = builtins.seq identityCheck (
      lib.listToAttrs
      (
        map
        (
          m:
            lib.nameValuePair m.spec.identity.hostname
            (builders.mkDarwin m.spec)
        )
        (byKind "darwin")
      )
    );

    homeConfigurations = builtins.seq identityCheck (
      lib.listToAttrs
      (
        map
        (
          m:
            lib.nameValuePair m.identity
            (builders.mkStandaloneHome m.spec)
        )
        (byKind "standalone")
      )
    );
  };

  builders = import ./builders.nix {
    inherit inputs common;
    profiles = profileCatalog;
    outputs = outputs;
  };
in
  outputs
