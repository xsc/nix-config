{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "f3758bba-06e1-42dc-b269-e60829593e62" = {
        credentialsFile = "${config.age.secrets."cloudflared.pem".path}";
        default = "http_status:404";
        ingress = {
          "photos.xsc.dev" = {
            service = "http://localhost:2283";
          };
        };
      };
    };
  };
}
