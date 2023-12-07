{ pkgs, ... }:

{
  # Enable fonts dir
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [ fira-code fira-code-nerdfont monaspace ];
}
