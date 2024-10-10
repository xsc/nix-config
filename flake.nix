{
  description = "Starter Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";

    # nix-darwin
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew
    nix-homebrew = {url = "github:zhaofengli-wip/nix-homebrew";};
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-numi-cask = {
      url = "github:nikolaeu/homebrew-numi";
      flake = false;
    };

    # secrets
    secrets = {
      url = "git+ssh://git@github.com/xsc/nix-secrets.git";
      flake = false;
    };

    # overlays
    alfred.url = "github:xsc/alfred-workflows-nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = {
    self,
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    homebrew-numi-cask,
    home-manager,
    nixpkgs,
    agenix,
    flake-utils,
    secrets,
    alfred,
    nix-vscode-extensions,
  } @ inputs: let
    # Darwin Hosts
    darwinSystems = with flake-utils.lib.system; [
      aarch64-darwin
      x86_64-darwin
    ];
    darwinHosts = ["moomin"];

    mkDarwinSystem = system: host: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      darwin.lib.darwinSystem {
        inherit system;

        specialArgs = inputs;
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            nix-homebrew = {
              enable = true;
              user = "yannick.scherer";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "nikolaeu/homebrew-numi" = homebrew-numi-cask;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./hosts/${host}
        ];
      };
    darwinConfigurations = flake-utils.lib.eachSystem darwinSystems (
      system: let
        lib = nixpkgs.legacyPackages.${system}.lib;
      in {
        packages = {
          darwinConfigurations = lib.genAttrs darwinHosts (host: mkDarwinSystem system host);
        };
      }
    );

    # NixOS Systems
    nixosSystems = with flake-utils.lib.system; [
      x86_64-linux
      aarch64-linux
    ];
    nixosHosts = ["condor" "llama"];
    mkNixosSystem = system: host:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/${host}
        ];
      };
    nixosConfigurations = flake-utils.lib.eachSystem nixosSystems (
      system: let
        lib = nixpkgs.legacyPackages.${system}.lib;
      in {
        packages = {
          nixosConfigurations = lib.genAttrs nixosHosts (host: mkNixosSystem system host);
        };
      }
    );

    # Development Shells
    mkDevShells = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          bashInteractive
          git
          openssh
          age
          age-plugin-yubikey
        ];
        shellHook = ''
          export EDITOR=vim
        '';
      };
    in {
      inherit default;
    };
    devShells =
      flake-utils.lib.eachDefaultSystem
      (system: {devShells = mkDevShells system;});
  in
    devShells
    // {
      packages = darwinConfigurations.packages // nixosConfigurations.packages;
    };
}
