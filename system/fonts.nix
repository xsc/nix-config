{ pkgs, ... }:

{
  # Enable fonts dir
  fonts.fontDir.enable = true;
  fonts.fonts = import ./packages/fonts.nix { inherit pkgs; };
}
