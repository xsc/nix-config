{ pkgs, ... }@inputs:

let
  programs = pkgs.callPackage ./home-manager/programs inputs;
  files = pkgs.callPackage ./home-manager/files inputs;
in
{
  imports = [
    ./overlays
    ./packages.nix
    ./secrets.nix
    ../base
  ];

  platform.programs = programs;
  platform.files = files;
}
