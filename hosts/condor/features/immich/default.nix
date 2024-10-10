{pkgs, ...}: {
  imports = [
    ./docker-compose.nix
  ];

  # Users/Groups
  users.groups.immich = {};
  users.users.immich = {
    isNormalUser = true;
    group = "immich";
    shell = pkgs.zsh;
    extraGroups = ["docker"];
  };

  # User Environment
  home-manager.users.immich = {pkgs, ...}: {
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
}
