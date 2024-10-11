{pkgs, ...}: let
  user = "yannick";
in {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./secrets.nix
    ../../platforms/base
    ../../platforms/development
    ./desktop
    ./keyboard
    ./dns.nix
  ];

  # Basics
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "llama";
  networking.networkmanager.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = false;
  };

  services = {
    hardware.bolt.enable = true;
    printing.enable = true;
    rtkit.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pcscd.enable = true;
  };

  # Nix
  nix = {
    package = pkgs.nixVersions.latest;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Key to decode secrets
  age.identityPaths = ["/home/yannick/.ssh/id_ed25519"];

  # Programs
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Theme
  theme.fontSize = 10;
  fonts.fontDir.enable = true;

  # Users
  users.users.yannick = {
    isNormalUser = true;
    description = "Yannick";
    extraGroups = ["networkmanager" "wheel" "agenix" "uinput" "input"];
    shell = pkgs.zsh;
  };

  home-manager.users."${user}" = {
    ageSecrets,
    config,
    ...
  }: let
    secretFile = n: {
      source =
        config.lib.file.mkOutOfStoreSymlink
        ageSecrets."${n}".path;
    };
  in {
    programs.git = {
      userName = "Yannick Scherer";
      userEmail = "yannick@xsc.dev";
      signing = {key = "FCC8CDA4";};
    };

    programs.zsh.shellAliases = {
      wgu = "sudo wg-quick up ${ageSecrets."wireguard.condor.conf".path}";
      wgd = "sudo wg-quick down ${ageSecrets."wireguard.condor.conf".path}";
    };

    home.file = {
      ".ssh/config.d/shared.ssh_config" = secretFile "shared.ssh_config";
      ".ssh/config.d/llama.ssh_config" = secretFile "llama.ssh_config";
      ".ssh/keys/id_ed25519_github" = secretFile "id_ed25519_github";
      ".ssh/keys/id_ed25519_condor" = secretFile "id_ed25519_condor";
    };

    home.stateVersion = "24.05";
  };

  # Do not edit
  system.stateVersion = "24.05";
}
