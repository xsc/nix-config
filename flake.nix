{
  description = "Starter Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:dustinlyons/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
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
    secrets = {
      url = "git+ssh://git@github.com/xsc/nix-secrets.git";
      flake = false;
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };
  outputs = { self, darwin, nix-homebrew, homebrew-bundle, homebrew-core
    , homebrew-cask, home-manager, nixpkgs, agenix, secrets
    , alacritty-theme }@inputs:
    let
      userData = import ./user.nix {};
      user = userData.user;
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" ];
      forAllLinuxSystems = f:
        nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f:
        nixpkgs.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
                age
                age-plugin-yubikey
              ];
              shellHook = with pkgs; ''
                export EDITOR=vim
              '';
            };
        };
    in {
      devShells = forAllSystems devShell;
      darwinConfigurations = let user = userData.user;
      in {
        macos = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = inputs // { inherit userData; };
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              nix-homebrew = {
                enable = true;
                user = "${user}";
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./system
          ];
        };
      };

    };
}
