{ pkgs, alacritty-theme, alfred, nix-vscode-extensions, ... }@inputs:

let
  # Simple overlays
  overlays = [
    alacritty-theme.overlays.default
    alfred.overlays.default
    nix-vscode-extensions.overlays.default
  ];

  # Other overlays from this directory
  importedOverlays =
    let path = ./.; in
    with builtins;
    map
      (n: import (path + ("/" + n)) inputs)
      (filter
        (n:
          n != "default.nix" && (
            match ".*\\.nix" n != null
            || pathExists (path + ("/" + n + "/default.nix"))
          ))
        (attrNames (readDir path)));
in
{
  nixpkgs.overlays = overlays ++ importedOverlays;
}
