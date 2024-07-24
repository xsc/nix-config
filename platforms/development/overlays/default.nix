{ nix-vscode-extensions, ... }:

{
  imports = [
    ./kanata.nix
  ];

  nixpkgs.overlays = [
    nix-vscode-extensions.overlays.default
  ];
}
