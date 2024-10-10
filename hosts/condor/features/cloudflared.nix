{config, ...}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "7989c7f2-e234-47a6-85fa-a74e1f3b9a0b" = {
        credentialsFile = "${config.age.secrets."cloudflared.json".path}";
        default = "http_status:404";
        ingress = {
          "*.xsc.dev" = {
            service = "http://localhost:2280";
          };
        };
      };
    };
  };
}
