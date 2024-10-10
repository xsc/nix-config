{
  pkgs,
  config,
  lib,
  theme,
  ...
} @ inputs: let
  path = ./.;
  imports = with builtins;
    map
    (n: import (path + ("/" + n)) inputs)
    (filter
      (n:
        n
        != "default.nix"
        && (
          match ".*\\.nix" n
          != null
          || pathExists (path + ("/" + n + "/default.nix"))
        ))
      (attrNames (readDir path)));
  binImports = with builtins;
    map
    (binFile: {
      ".bin/${binFile}" = {
        source = "${./bin}/${binFile}";
        executable = true;
      };
    })
    (attrNames (readDir ./bin));
in
  lib.mkMerge (imports ++ binImports)
