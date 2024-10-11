{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../platforms/base
    ./hardware-configuration.nix
    ./secrets.nix
    ./features
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = "23.11";

  # Networking
  networking = {
    hostName = "io";
    domain = "xsc.dev";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };

  # Features
  programs.zsh.enable = true;
  virtualisation = {
    containers.enable = true;
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  # Packages
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Security
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "24h";
  };

  # Root User
  users.users.root = {
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiDYplrT5/5GsOtGJKW7/bYbSNt7pqNwutGwY0Y1fFv yannick@moomin''
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfGfD5K7AWAdq2d0mRJeZXOtxnzvLVOfXyHtlpCo1zw yannick@llama''
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.root = {
    programs.git = {
      userName = "Yannick Scherer";
      userEmail = "yannick@xsc.dev";
    };

    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = config.age.secrets."duplicity.gpg".path;
          trust = 4;
        }
      ];
    };
  };
}
