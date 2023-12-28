{ config, pkgs, lib, userData, theme, ... }:

let
  importPkg = f: import f { inherit config pkgs lib userData theme; };

  path = ./.;
  importedPrograms = lib.mkMerge (with builtins;
    map (n: importPkg (path + ("/" + n))) (filter
      (n:
        n != "default.nix" && (match ".*\\.nix" n != null
        || pathExists (path + ("/" + n + "/default.nix"))))
      (attrNames (readDir path))));
in
importedPrograms // { home-manager.enable = true; }
