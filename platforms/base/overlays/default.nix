{ pkgs, ... }@inputs:

let
  importedOverlays =
    let path = ./.; in
    map
      (n: import (path + ("/" + n)) inputs)
      (builtins.filter
        (n:
          n != "default.nix" && (
            builtins.match ".*\\.nix" n != null
            || builtins.pathExists (path + ("/" + n + "/default.nix"))
          ))
        (builtins.attrNames (builtins.readDir path)));
in
{
  nixpkgs.overlays = importedOverlays;
}
