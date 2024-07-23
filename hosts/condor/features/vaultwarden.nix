{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vaultwarden.xsc.dev";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 2285;
      SIGNUPS_ALLOWED = false;

      # Important to correctly log the IP for fail2ban to pick up
      IP_HEADER = "X-Forwarded-For";
    };
    environmentFile = config.age.secrets."vaultwarden.env".path;
  };

  services.fail2ban.jails =
    let
      mkSettings = filter: {
        inherit filter;

        enabled = true;
        backend = "systemd";
        action = "action-ban-vaultwarden";
        maxretry = 3;
        findtime = 300;
        bantime = "24h";
        journalmatch = "_SYSTEMD_UNIT=vaultwarden.service";
      };
    in
    {
      "vaultwarden".settings = mkSettings "vaultwarden";
      "vaultwarden-admin".settings = mkSettings "vaultwarden-admin";
    };

  environment.etc = {
    "fail2ban/filter.d/vaultwarden.conf".text = ''
      [Definition]
      failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username: <F-USER>.*</F-USER>\.$
      ignoreregex =
    '';

    "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
      [Definition]
      failregex = ^.*Invalid admin token. IP: <ADDR>.*$
      ignoreregex =
    '';

    "fail2ban/action.d/action-ban-vaultwarden.conf".text = ''
      [Definition]
      actionban = iptables -I INPUT -p tcp --dport 2285 -m string --algo bm --string 'X-Forwarded-For: <ip>' -j DROP
      actionunban = iptables -D INPUT -p tcp --dport 2285 -m string --algo bm --string 'X-Forwarded-For: <ip>' -j DROP
    '';
  };

}
