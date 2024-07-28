{ config, ... }:

{
  imports = [
    ./overlays
    ./packages.nix
    ./secrets.nix
  ];

  home-manager.sharedModules = [
    ./home-manager/programs
    ./home-manager/files
  ];

  home-manager.extraSpecialArgs.ageSecrets = config.age.secrets;
}
