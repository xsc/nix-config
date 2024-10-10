{config, ...}: {
  networking.firewall.interfaces.wg0 = {
    allowedTCPPorts = [443];
    allowedUDPPorts = [53];
  };

  networking.firewall.interfaces.ens18.allowedUDPPorts = [5553];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.1/24"];
      listenPort = 5553;
      privateKeyFile = config.age.secrets."wireguard.key".path;
      peers = [
        {
          # graphene
          publicKey = "feBfsj/ejXqqVm7RAxUdmZ3s7gnzKvGY5BSWhSCDFwA=";
          allowedIPs = ["10.100.0.101/32"];
        }
        {
          # llama
          publicKey = "pnI8p6PxQiqcDMeLf7zzB1/Ar7jey7DDpquOevYHqT0=";
          allowedIPs = ["10.100.0.102/32"];
        }
        {
          # moomin
          publicKey = "L2MeI0lb85qZyO9Js5Gp2EvZkMb46rQVhsDwBQeYwgc=";
          allowedIPs = ["10.100.0.103/32"];
        }
      ];
    };
  };

  services.fail2ban.ignoreIP = ["10.100.0.0/24"];
}
