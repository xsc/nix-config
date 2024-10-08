{ config, pkgs, ... }:

{
  systemd.services."dnsmasq-local" = {
    script = ''
        ${pkgs.dnsmasq}/bin/dnsmasq --listen-address=127.0.0.1 --port=53 --conf-file=${config.age.secrets."dnsmasq-nextdns.conf".path} --keep-in-foreground
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
