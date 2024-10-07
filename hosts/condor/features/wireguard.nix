{ config, ... }:
{
  networking.firewall.interfaces.wg0 = {
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 53 ];
  };

  networking.firewall.interfaces.ens18.allowedUDPPorts = [ 5553 ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 5553;
      privateKeyFile = config.age.secrets."wireguard.key".path;
      peers = [
        {
          # devices
          publicKey = "feBfsj/ejXqqVm7RAxUdmZ3s7gnzKvGY5BSWhSCDFwA=";
          allowedIPs = [ "10.100.0.101/32" "10.100.0.102/32" ];
        }
      ];
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wg0";
      address = [ "/xsc.dev/10.100.0.1" ];
    };
  };

  services.fail2ban.ignoreIP = [ "10.100.0.0/24" ];
}
