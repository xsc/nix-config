{ config, pkgs, ... }:

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
    };
  };
}
