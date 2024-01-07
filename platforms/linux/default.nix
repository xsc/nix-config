{ agenix, alfred, userData, pkgs, ... }:

{
  imports = [
    ../shared/nixpkgs.nix
    ../shared/overlays
    ../shared/secrets.nix
    ./home-manager
    agenix.homeManagerModules.default
  ];
}
