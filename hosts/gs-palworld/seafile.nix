{pkgs, ... }:
{
  services.seafile = {
    enable = true;
    adminEmail = "dty2015@hotmail.com";
    initialAdminPassword = "admin";

    # ccnetSettings.General.SERVICE_URL = "https://seafile.example.com";
    ccnetSettings.General.SERVICE_URL = "http://192.168.1.208";

    seafileSettings = {
      fileserver = {
    #     host = "unix:/run/seafile/server.sock";
        host = "0.0.0.0";
      };
    };

    seahubAddress = "0.0.0.0:8083";

  };
}
