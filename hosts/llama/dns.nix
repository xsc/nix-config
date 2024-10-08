{
  config,
  pkgs,
  ...
}: {
  users.groups.stubby = {};
  users.users.stubby = {
    isSystemUser = true;
    group = "stubby";
  };

  systemd.services.stubby = {
    script = ''
      ${pkgs.stubby}/bin/stubby -C "${config.age.secrets."stubby.nextdns.yml".path}"
    '';
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "1";
      User = "stubby";
      DynamicUser = "yes";
      CacheDirectory = "stubby";
      WorkingDirectory = "/var/cache/stubby";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      LockPersonality = "true";
      MemoryDenyWriteExecute = "true";
      NoNewPrivileges = "true";
      PrivateDevices = "true";
      PrivateTmp = "true";
      PrivateUsers = "false";
      ProtectClock = "true";
      ProtectControlGroups = "true";
      ProtectHome = "true";
      ProtectHostname = "true";
      ProtectKernelLogs = "true";
      ProtectKernelModules = "true";
      ProtectKernelTunables = "true";
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
      RestrictNamespaces = "true";
      RestrictRealtime = "true";
      RestrictSUIDSGID = "true";
      SystemCallArchitectures = "native";
      SystemCallFilter = "@system-service";
      SystemCallErrorNumber = "EPERM";
    };
    unitConfig = {
      Wants = ["network-online.target"];
      After = ["network-online.target"];
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services."dnsmasq-wireguard" = {
    script = ''
      ${pkgs.dnsmasq}/bin/dnsmasq --listen-address=10.100.0.102 --port=53 --server=/xsc.dev/10.100.0.1 --server=127.0.0.1 --bind-interfaces --keep-in-foreground
    '';
  };

  networking.nameservers = ["127.0.0.1"];
}
