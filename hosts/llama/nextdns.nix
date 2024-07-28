{ config, pkgs, ... }:

{
  systemd.services.nextdns = {
    script = ''
      ${pkgs.nextdns}/bin/nextdns run -config-file ${config.age.secrets."nextdns.conf".path}
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
