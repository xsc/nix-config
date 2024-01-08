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
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      inherit programs;

      home.enableNixpkgsReleaseCheck = false;
      home.packages = (pkgs.callPackage ../packages { })
        ++ (pkgs.callPackage ../../shared/packages { })
        ++ [ agenix.packages."${pkgs.system}".default ];
      home.file = files;
      home.stateVersion = "21.11";

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;

      # Others
      launchd.enable = true;
    };
  };
}
