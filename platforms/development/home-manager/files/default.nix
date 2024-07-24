{ lib, ... }@inputs:

let
  path = ./.;
  imports =
    map
      (n: import (path + ("/" + n)) inputs)
      (builtins.filter
        (n:
          n != "default.nix" && (
            builtins.match ".*\\.nix" n != null
            || builtins.pathExists (path + ("/" + n + "/default.nix"))
          ))
        (builtins.attrNames (builtins.readDir path)));
  binImports =
    with builtins;
    map
      (binFile: {
        ".bin/${ binFile}" = {
          source = "${./bin}/${binFile}";
          executable = true;
        };
      })
      (attrNames (readDir ./bin));
in
lib.mkMerge (imports ++ binImports)

