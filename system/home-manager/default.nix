{ agenix, userData, theme, ... }@inputs:

{
  home-manager = {
    useGlobalPkgs = true;
    users.${userData.user} = { config, lib, pkgs, ... }:
      let
        homeConfiguration = import ./home.nix {
          inherit agenix config lib pkgs theme userData;
        };
      in
      {
        inherit (homeConfiguration) home;
      };
  };
}
