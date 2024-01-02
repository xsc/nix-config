{ agenix, config, lib, pkgs, userData, theme, ... }:

let
  # Helper
  importPkg = f: import f { inherit config pkgs lib userData theme; };

  # Home Manager Data
  user = userData.user;
  programs = importPkg ./programs;
  files = importPkg ./files;
  packages = importPkg ../packages;

in
{
  # What to manage
  home.username = userData.user;
  home.homeDirectory = userData.homeDirectory;

  # Settings
  home.stateVersion = "23.11";
  home.enableNixpkgsReleaseCheck = false;

  # Elements
  home.file = files;
  home.packages = packages
    ++ [ agenix.packages."${pkgs.system}".default ];
  inherit programs;

  # Pick up fonts from packages
  fonts.fontconfig.enable = true;

  # Marked broken Oct 20, 2022 check later to remove this
  # https://github.com/nix-community/home-manager/issues/3344
  manual.manpages.enable = false;

}
