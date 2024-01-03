{ config, pkgs, userData, ... }:

{
  # nextdns
  # -> NOTE: Could not use 'services.nextdns' because arguments were escaped
  #          incorrectly. :(
  launchd.daemons.nextdns = {
    # Do not set `path` here, otherwise we're at risk of `nextdns` not finding
    # `networksetup` (which resides at `/usr/sbin`).
    path = [ ];

    serviceConfig = {
      ProgramArguments =
        [ "${pkgs.nextdns}/bin/nextdns" "run" "-config-file" "${config.age.secrets."nextdns.conf".path}" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/nextdns-stdout.log";
      StandardErrorPath = "/var/log/nextdns-stderr.log";
    };
  };

  launchd.daemons.kanata = {
    path = [ ];

    serviceConfig = {
      ProgramArguments =
        [ "${pkgs.kanata-custom}/bin/kanata" "-c" "${userData.home}/.config/kanata/colemak-dh.kbd" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/kanata-stdout.log";
      StandardErrorPath = "/var/log/kanata-stderr.log";
    };
  };
}
