{ agenix, config, lib, pkgs, userData, theme, ... }:
let packages = (pkgs.callPackage ./packages.nix { }) ++ [ agenix.packages."${pkgs.system}".default ];
in
{
  imports = [
    ../../platforms/shared/overlays
    ./hardware-configuration.nix
    ./secrets.nix
    ./features
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = "23.11";

  # Networking
  networking = {
    hostName = "io";
    domain = "xsc.dev";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # Features
  programs.zsh.enable = true;
  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  # Security
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "24h";
  };

  # Root User
  users.users.root = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiDYplrT5/5GsOtGJKW7/bYbSNt7pqNwutGwY0Y1fFv yannick@pop-os''
    ];
  };

  home-manager.users.root =
    let
      importPkg = f: import f { inherit config pkgs lib userData theme; };
      importShared = n:
        let path = ../../platforms/shared/home-manager/programs/${n}; in
        if (builtins.pathExists path) then
          (importPkg path)
        else
          (importPkg (path + ".nix"));
    in
    { ... }:
    {
      programs = lib.mkMerge [
        (importShared "git")
        (importShared "nvim")
        (importPkg ./zsh.nix)
        {
          gpg = {
            enable = true;
            publicKeys = [
              {
                source = config.age.secrets."duplicity.gpg".path;
                trust = 4;
              }
            ];
          };
        }
      ];
      home.packages = packages;
      home.stateVersion = "24.05";
    };

  # Packages
  environment.systemPackages = packages;
}

