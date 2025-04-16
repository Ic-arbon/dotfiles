# GitLab 配置文件
{ config, pkgs, lib, ... }:

{
  # 启用 GitLab 服务
  services.gitlab = {
    enable = true;
    
    # 主机设置
    host = "gs-palworld";
    port = 8080;
    https = false; # 如果您需要HTTPS，请将此设为true并配置好证书
    
    # 创建安全的密码文件
    databasePasswordFile = "/var/keys/gitlab/db_password";
    initialRootPasswordFile = "/var/keys/gitlab/root_password";
    
    # GitLab 密钥配置
    secrets = {
      secretFile = "/var/keys/gitlab/secret";
      otpFile = "/var/keys/gitlab/otp_secret";
      dbFile = "/var/keys/gitlab/db_secret";
      jwsFile = "/var/keys/gitlab/jws_key";
    };
    
    # 邮件配置（可选）
    # smtp = {
    #   enable = true;
    #   address = "smtp.example.com";
    #   port = 587;
    #   username = "gitlab@example.com";
    #   passwordFile = "/var/keys/gitlab/smtp_password";
    # };
    
    # 备份配置
    backup = {
      enable = true;
      path = "/var/gitlab/backups";
      interval = "40 22 * * *"; # 每天22点40分备份
    };
  };

  # 配置 Nginx 作为反向代理
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    
    virtualHosts."gs-palworld" = {
      # 如果您有域名，可以使用该域名
      serverName = "icarbon.link";
      
      # 将所有请求代理到 GitLab
      locations."/" = {
        proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        proxyWebsockets = true;
      };
      
      # 如果需要启用HTTPS，取消下面的注释并配置证书
      # enableACME = true;
      # forceSSL = true;
    };
  };

  # 配置防火墙以允许 GitLab 和 Nginx 访问
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22     # SSH
      80     # HTTP
      443    # HTTPS（如果需要）
      8080   # GitLab 端口
    ];
  };

  # 创建存储密钥的目录
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
  '';
} 