{ config, pkgs, ... }:
{
  users.groups.msmtp = {};
  users.users.msmtp = {
    group = "msmtp";
    isNormalUser = true;
  };

  home-manager.users.msmtp = { ... }: {
    programs = {
      msmtp = {
        enable = true;
      };
    };

    accounts.email.accounts.smtp2go = {
      msmtp.enable = true;

      smtp.tls.enable = true;
      smtp.tls.useStartTls = true;
      smtp.host = "mail.smtp2go.com";
      smtp.port = 2525;

      primary = true;
      address = "noreply@photos.xsc.dev";
      userName = "photos.xsc.dev";
      passwordCommand =
        "${pkgs.coreutils}/bin/cat ${config.age.secrets."smtp2go.pwd".path}";
    };

    home.stateVersion = "24.05";
  };
}
