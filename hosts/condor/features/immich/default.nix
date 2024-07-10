{ pkgs, ... }:
{

  imports = [
    ./docker-compose.nix
  ];

  # Users/Groups
  users.groups.immich = { };
  users.users.immich = {
    isNormalUser = true;
    group = "immich";
    shell = pkgs.zsh;
    extraGroups = [ "docker" ];
  };

  # User Environment
  home-manager.users.immich = { pkgs, ... }: {
    programs = {
      zsh = {
        enable = true;
      };
    };
    home.packages = with pkgs; [
      docker
      docker-compose
    ];
    home.stateVersion = "24.05";
  };

  # Directory
  systemd.tmpfiles.rules = [
    "d /var/immich 0755 immich immich"
  ];

  # Virtual Host
  services.nginx.virtualHosts = {
    "photos.xsc.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_pass_header Authorization;
        '';
      };
    };
  };
}
