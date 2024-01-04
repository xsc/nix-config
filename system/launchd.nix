{ config, pkgs, userData, ... }:

let logs = "/var/log/nixos-launchd"; in
{
  # nextdns
  # -> NOTE: Could not use 'services.nextdns' because arguments were escaped
  #          incorrectly. :(
  launchd.daemons.nextdns = {
    # Do not set `path` here, otherwise we're at risk of `nextdns` not finding
    # `networksetup` (which resides at `/usr/sbin`).
    path = [ ];

    serviceConfig = {
      EnvironmentVariables = {
        SERVICE_RUN_MODE = "1";
      };

      Program = "${pkgs.nextdns}/bin/nextdns";
      ProgramArguments =
        [ "${pkgs.nextdns}/bin/nextdns" "run" "-config-file" "${config.age.secrets."nextdns.conf".path}" ];

      StandardOutPath = "${logs}/nextdns-stdout.log";
      StandardErrorPath = "${logs}/nextdns-stderr.log";
      KeepAlive = true;
      Disabled = false;
    };
  };

  launchd.daemons.kanata = {
    path = [ ];

    serviceConfig = {
      Program = "${pkgs.kanata-custom}/bin/kanata";
      ProgramArguments =
        [ "${pkgs.kanata-custom}/bin/kanata" "-c" "${./home-manager/files/kanata/colemak-dh.kbd}" ];

      StandardOutPath = "${logs}/kanata-stdout.log";
      StandardErrorPath = "${logs}/kanata-stderr.log";
      KeepAlive = true;
      Disabled = false;
    };
  };
}
