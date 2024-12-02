{
  config,
  lib,
  ...
}: let
  services = [
    {
      name = "md";
      port = 2284;
    }
    {
      name = "photos";
      port = 2283;
    }
    {
      name = "social";
      port = 2286;
    }
    {
      name = "vaultwarden";
      port = 2285;
    }
    {
      name = "feeds";
    }
  ];
in {
  # We're running an nginx server on localhost, as well as on the Wireguard
  # interface. This will allow us to both point a cloudflare tunnel at it,
  # as well as directly access it when connected via Wireguard.
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    clientMaxBodySize = "4g";

    virtualHosts = let
      proxy = {
        name,
        port ? null,
      }:
        {
          listen = [
            {
              addr = "127.0.0.1";
              port = 2280;
              ssl = false;
            }
            {
              addr = "10.100.0.1";
              port = 443;
              ssl = true;
            }
          ];

          addSSL = true;
          useACMEHost = "${name}.xsc.dev";
        }
        // (
          if (port != null)
          then {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString port}/";
              proxyWebsockets = true;
              extraConfig =
                "proxy_ssl_server_name on;"
                + "proxy_pass_header Authorization;";
            };
          }
          else {}
        );
    in
      builtins.listToAttrs (
        builtins.map
        (data: (lib.nameValuePair "${data.name}.xsc.dev" (proxy data)))
        services
      );
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "infra@xsc.dev";

    certs = builtins.listToAttrs (
      builtins.map
      (data: (lib.nameValuePair "${data.name}.xsc.dev"
        {
          domain = "${data.name}.xsc.dev";
          dnsProvider = "cloudflare";
          credentialsFile = config.age.secrets."acme.env".path;
          inherit (config.services.nginx) group;
        }))
      services
    );
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wg0";
      host-record =
        builtins.map
        (data: "${data.name}.xsc.dev,10.100.0.1")
        services;
    };
  };
}
