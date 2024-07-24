{ lib, pkgs, ... }@inputs:

let
  importPkg = f: pkgs.callPackage f inputs;
  path = ./.;
  programs = lib.mkMerge
    (map (n: importPkg (path + ("/" + n)))
      (builtins.filter
        (n:
          n != "default.nix" && (builtins.match ".*\\.nix" n != null
          || builtins.pathExists (path + ("/" + n + "/default.nix"))))
        (builtins.attrNames (builtins.readDir path))));
in
programs
