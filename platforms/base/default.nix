{
  agenix,
  config,
  lib,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ./utils/cachix
    ./overlays
    ./packages.nix
    ./theme.nix
  ];

  # Base Packages
  environment.systemPackages = [agenix.packages."${pkgs.system}".default];

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.sharedModules = [
    {
      home.enableNixpkgsReleaseCheck = false;
      home.packages = config.environment.systemPackages;
      home.stateVersion = lib.mkDefault "24.05";
    }
    ./home-manager/programs
  ];
  home-manager.extraSpecialArgs = {
    userHome = config.userHome;
  };

  # Nix Settings
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };

  # State Version
  system.stateVersion = lib.mkDefault "24.05";
}
