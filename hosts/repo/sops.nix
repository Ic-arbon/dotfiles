{ inputs, ...}:
{
  # imports = [ <sops-nix/modules/sops> ];
  imports = [ inputs.sops-nix.nixosModules.sops ];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/home/tyd/.ssh/authorized_keys" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/home/tyd/.config/sops/age/keys.txt";
  # This will generate a new key if the key specified above does not exist
  # sops.age.generateKey = true;
  # This is the actual specification of the secrets.
  # sops.secrets.example-key = {};
  sops.secrets."forgejo/admin/tyd_secret" = {};
}
