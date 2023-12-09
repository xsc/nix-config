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
    homebrew-numi-cask = {
      url = "github:nikolaeu/homebrew-numi";
      flake = false;
    };
    secrets = {
      url = "git+ssh://git@github.com/xsc/nix-secrets.git";
      flake = false;
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    alfred.url = "github:xsc/alfred-workflows-nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs =
    { self
    , darwin
    , nix-homebrew
    , homebrew-bundle
    , homebrew-core
    , homebrew-cask
    , homebrew-numi-cask
    , home-manager
    , nixpkgs
    , agenix
    , secrets
    , alacritty-theme
    , alfred
    , nix-vscode-extensions
    }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      userData = import ./user.nix { };
      theme = import ./theme.nix { };
      devShell = {
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
    in
    {
      devShells = [ devShell ];
      darwinConfigurations = {
        macos = darwin.lib.darwinSystem {
          inherit system;

          specialArgs = inputs // { inherit userData theme; };
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              nix-homebrew =
                {
                  enable = true;
                  user = "${userData.user}";
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
            ./system
          ];
        };
      };

    };
}
