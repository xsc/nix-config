{ config, lib, pkgs, userData, theme, ... }:

let
  # Helper
  importPkg = f: import f { inherit config pkgs lib userData theme; };

  # User Info
  user = userData.user;

  # Program Configurations
  path = ./programs;
  programs = lib.mkMerge (with builtins;
    map (n: importPkg (path + ("/" + n))) (filter
      (n:
        n != "default.nix" && (match ".*\\.nix" n != null
        || pathExists (path + ("/" + n + "/default.nix"))))
      (attrNames (readDir path))));

  # Files
  files = importPkg ./files;

in
{
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      inherit programs;

      home.enableNixpkgsReleaseCheck = false;
      home.packages = (pkgs.callPackage ./packages { })
        ++ [ pkgs.dockutil ];
      home.file = files;
      home.stateVersion = "21.11";

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };
}
