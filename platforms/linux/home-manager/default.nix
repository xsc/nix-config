{ agenix, config, lib, pkgs, userData, theme, ... }:

let
  # Helper
  importPkg = f: import f { inherit config pkgs lib userData theme; };

  # Data
  user = userData.user;
  programs = lib.mkMerge [
    (importPkg ./programs)
    (importPkg ../../shared/home-manager/programs)
  ];
  files = lib.mkMerge [
    (importPkg ./files)
    (importPkg ../../shared/home-manager/files)
  ];
in
{
  # What to manage
  home.username = userData.user;
  home.homeDirectory = userData.home;

  # Settings
  home.stateVersion = "21.11";
  home.enableNixpkgsReleaseCheck = false;

  # Packages & Files
  inherit programs;
  home.packages = (pkgs.callPackage ../packages { })
    ++ (pkgs.callPackage ../../shared/packages { })
    ++ [ agenix.packages."${pkgs.system}".default ];
  home.file = files;

  # pick up fonts from packages
  fonts.fontconfig.enable = true;

  # Marked broken Oct 20, 2022 check later to remove this
  # https://github.com/nix-community/home-manager/issues/3344
  manual.manpages.enable = false;
}
