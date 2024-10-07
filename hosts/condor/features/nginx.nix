{ config, ... }:
{
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
  };

  services.nginx.virtualHosts =
    let
      proxy = port: {
        listen = [
          { addr = "127.0.0.1"; port = 2280; ssl = false; }
          { addr = "10.100.0.1"; port = 443; ssl = true; }
        ];

        addSSL = true;
        useACMEHost = "xsc.dev";

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}/";
          proxyWebsockets = true;
          extraConfig =
            "proxy_ssl_server_name on;" +
            "proxy_pass_header Authorization;"
          ;
        };
      };
    in
    {
      "md.xsc.dev" = proxy 2284;
      "photos.xsc.dev" = proxy 2283;
      "social.xsc.dev" = proxy 2286;
      "vaultwarden.xsc.dev" = proxy 2285;
    };

  security.acme = {
    acceptTerms = true;
    defaults.email = "infra@xsc.dev";

    certs."xsc.dev" = {
      domain = "*.xsc.dev";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."acme.env".path;
      group = config.services.nginx.group;
    };
  };
}
