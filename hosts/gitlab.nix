{ config, pkgs, lib, ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."icarbon.link" = {
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };

  services.gitlab = {
    enable = true;
    # packages.gitlab = pkgs.gitlab-ee;

    host = "icarbon.link";
    https = false;
    port = 80;

    databasePasswordFile = "/var/keys/gitlab/db_password";
    initialRootPasswordFile = "/var/keys/gitlab/root_password";

    # databaseCreateLocally = true;
    # databaseUsername = "gitlab";
    # user = "gitlab";
    # group = "gitlab";

    # smtp = {
    #   enable = true;
    #   address = "localhost";
    #   port = 25;
    # };

    secrets = {
      dbFile = "/var/keys/gitlab/db";
      secretFile = "/var/keys/gitlab/secret";
      otpFile = "/var/keys/gitlab/otp";
      jwsFile = "/var/keys/gitlab/jws";
    };
    # extraConfig = {
    #   gitlab = {
    #     email_from = "gitlab-no-reply@example.com";
    #     email_display_name = "Example GitLab";
    #     email_reply_to = "gitlab-no-reply@example.com";
    #     default_projects_features = { builds = false; };
    #   };
    # };
  };

  system.activationScripts.gitlabKeys = ''
    mkdir -p /var/keys/gitlab
    chmod 700 /var/keys/gitlab
    
    # 如果密钥文件不存在，则创建它们
    if [ ! -f /var/keys/gitlab/db_password ]; then
      ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/keys/gitlab/db_password
      chmod 600 /var/keys/gitlab/db_password
    fi
    
    if [ ! -f /var/keys/gitlab/root_password ]; then
      ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/keys/gitlab/root_password
      chmod 600 /var/keys/gitlab/root_password
    fi
    
    if [ ! -f /var/keys/gitlab/secret ]; then
      ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/keys/gitlab/secret
      chmod 600 /var/keys/gitlab/secret
    fi
    
    if [ ! -f /var/keys/gitlab/otp_secret ]; then
      ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/keys/gitlab/otp_secret
      chmod 600 /var/keys/gitlab/otp_secret
    fi
    
    if [ ! -f /var/keys/gitlab/db_secret ]; then
      ${pkgs.openssl}/bin/openssl rand -base64 32 > /var/keys/gitlab/db_secret
      chmod 600 /var/keys/gitlab/db_secret
    fi
    
    if [ ! -f /var/keys/gitlab/jws_key ]; then
      ${pkgs.openssl}/bin/openssl genrsa 2048 > /var/keys/gitlab/jws_key
      chmod 600 /var/keys/gitlab/jws_key
    fi

    chown -R gitlab:gitlab /var/keys/gitlab
  '';

}
