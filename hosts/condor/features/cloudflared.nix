{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "7989c7f2-e234-47a6-85fa-a74e1f3b9a0b" = {
        credentialsFile = "${config.age.secrets."cloudflared.json".path}";
        default = "http_status:404";
        ingress = {
          "md.xsc.dev" = {
            service = "http://localhost:2284";
          };
          "photos.xsc.dev" = {
            service = "http://localhost:2283";
          };
          "social.xsc.dev" = {
            service = "http://localhost:2286";
          };
          "vaultwarden.xsc.dev" = {
            service = "http://localhost:2285";
          };
        };
      };
    };
  };
}
