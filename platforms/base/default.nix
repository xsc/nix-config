{
  agenix,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./utils/cachix
    ./overlays
    ./packages.nix
    ./theme.nix
  ];

  # Base Packages
  environment.systemPackages = [agenix.packages."${pkgs.system}".default];

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    sharedModules = [
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = config.environment.systemPackages;
          stateVersion = lib.mkDefault "24.05";
        };
      }
      ./home-manager/programs
    ];
    extraSpecialArgs = {
      inherit (config) userHome;
    };
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
