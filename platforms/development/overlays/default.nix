{ alacritty-theme, nix-vscode-extensions, pkgs, ... }@inputs:

let
  overlays = [
    alacritty-theme.overlays.default
    nix-vscode-extensions.overlays.default
  ];
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
  nixpkgs.overlays = overlays ++ importedOverlays;
}
