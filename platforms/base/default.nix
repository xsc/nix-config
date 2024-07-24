{ agenix, config, pkgs, lib, ... }@inputs:

{
  imports = [
    ./utils/cachix
    ./overlays
    ./packages.nix
  ];

  options.platform = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "root" ];
    };
    programs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    files = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    extraOpts = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = let programs = pkgs.callPackage ./home-manager/programs inputs; in {

    # Special Packages
    environment.systemPackages = [ agenix.packages."${pkgs.system}".default ];

    # Users
    users.users = lib.genAttrs config.platform.users
      (user: {
        shell = pkgs.zsh;
      });

    # Home Manager
    home-manager.useGlobalPkgs = true;
    home-manager.users = lib.genAttrs config.platform.users
      (user: { ... }: lib.mkMerge [
        {
          programs = programs // config.platform.programs;

          home.enableNixpkgsReleaseCheck = false;
          home.file = config.platform.files;
          home.packages = config.environment.systemPackages;
          home.stateVersion = lib.mkDefault "24.05";
        }
        config.platform.extraOpts
      ]);

    # Nix Settings
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
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
  };
}

