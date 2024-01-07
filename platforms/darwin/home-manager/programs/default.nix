{ config, lib, pkgs, userData, theme, ... }:

let
  importPkg = f: import f { inherit config pkgs lib userData theme; };
  path = ./.;
  programs = lib.mkMerge
    (with builtins;
    map (n: importPkg (path + ("/" + n))) (filter
      (n:
        n != "default.nix" && (match ".*\\.nix" n != null
        || pathExists (path + ("/" + n + "/default.nix"))))
      (attrNames (readDir path))));
in
programs

