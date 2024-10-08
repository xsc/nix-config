{ config, pkgs, ... }:

{
  systemd.services."dnsmasq-local" = {
    script = ''
        ${pkgs.dnsmasq}/bin/dnsmasq --listen-address=127.0.0.1 --port=53 --conf-file=${config.age.secrets."dnsmasq-nextdns.conf".path} --keep-in-foreground
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."dnsmasq-wireguard" = {
    script = ''
        ${pkgs.dnsmasq}/bin/dnsmasq --listen-address=10.100.0.102 --port=53 --server=/xsc.dev/10.110.0.1 --server=127.0.0.1 --keep-in-foreground
    '';
  };
}
