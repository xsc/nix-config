{
  config,
  pkgs,
  ...
}: let
  logs = "/var/log/nixos-launchd";
  waitAndRun = args:
  # we have to wait for the Nix store to be mounted, otherwise the daemons
  # fail with status 78. This logic creates a script that will wait for any
  # path in the arglist (identified by '/'). We do this because not every
  # relevant path points directly at the Nix store, some are symlinks.
  let
    waitFiles =
      builtins.filter
      (arg: (builtins.substring 0 1 arg) == "/")
      args;
    waitScripts = map (path: "/bin/wait4path ${path}") waitFiles;
    script =
      builtins.concatStringsSep
      " &amp;&amp; "
      (waitScripts
        ++ [
          (builtins.concatStringsSep " " args)
        ]);
  in ["/bin/sh" "-c" script];
in {
  launchd.daemons = {
    "nextdns" = {
      path = [];
      serviceConfig = {
        EnvironmentVariables = {
          SERVICE_RUN_MODE = "1";
        };

        ProgramArguments = waitAndRun [
          "${pkgs.nextdns}/bin/nextdns"
          "run"
          "-config-file"
          "${config.age.secrets."nextdns.conf".path}"
        ];

        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${logs}/nextdns-stdout.log";
        StandardErrorPath = "${logs}/nextdns-stderr.log";
      };
    };

    # On-demand DNS when the Wireguard tunnel starts up
    "dnsmasq-wireguard" = {
      serviceConfig.ProgramArguments = waitAndRun [
        "${pkgs.dnsmasq}/bin/dnsmasq"
        "--listen-address=10.100.0.103"
        "--port=53"
        "--server=/xsc.dev/10.100.0.1"
        "--server=127.0.0.1"
        "--keep-in-foreground"
      ];
      serviceConfig.OnDemand = true;
    };

    # Keyboard Remapping
    kanata = {
      path = [];

      serviceConfig = {
        ProgramArguments = waitAndRun [
          "${pkgs.kanata}/bin/kanata"
          "-c"
          "${./home-manager/files/kanata/colemak-dh.kbd}"
        ];

        RunAtLoad = true;
        StandardOutPath = "${logs}/kanata-stdout.log";
        StandardErrorPath = "${logs}/kanata-stderr.log";
        KeepAlive = true;
        Disabled = true;
      };
    };
  };
}
