{
  config,
  pkgs,
  ...
}: {
  users.groups.msmtp = {};
  users.users.msmtp = {
    group = "msmtp";
    isNormalUser = true;
    extraGroups = ["systemd-journal"];
  };

  home-manager.users.msmtp = _: {
    programs = {
      msmtp = {
        enable = true;
      };
    };

    accounts.email.accounts.smtp2go = {
      msmtp.enable = true;

      smtp = {
        tls = {
          enable = true;
          useStartTls = true;
        };
        host = "mail.smtp2go.com";
        port = 2525;
      };

      primary = true;
      address = "noreply@condor.xsc.dev";
      userName = "condor.xsc.dev";
      realName = "condor.xsc.dev";
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."smtp2go.pwd".path}";
    };

    home.stateVersion = "24.05";
  };

  systemd.services."notify-failure@" = let
    notifyScript = pkgs.writeScript "notify" ''
      #!${pkgs.bash}/bin/bash
      set -eu

      MESSAGE=$(cat <<EOM
      To: infra@xsc.dev
      Content-Type: text/plain; charset=utf-8
      Subject: [systemd] failed: $1

      Status
      =======
      $(SYSTEMD_COLORS=false systemctl status "$1")

      Journal
      =======
      $(SYSTEMD_COLORS=false journalctl -n 25 -xeu "$1")
      EOM
      )

      echo -n "$MESSAGE" | ${pkgs.msmtp}/bin/msmtp --account smtp2go --read-recipients
    '';
  in {
    enable = true;
    serviceConfig = {
      Type = "oneshot";
      User = "msmtp";
      Group = "msmtp";
      ExecStart = "${notifyScript} %i";
    };
  };
}
