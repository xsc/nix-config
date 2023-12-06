{ config, pkgs, userData, ... }:

{
  imports = [ ./options.nix ];

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Firefox.app/"; }
    { path = "/${pkgs.alacritty}/Applications/Alacritty.app/"; }
    { path = "/Applications/Slack.app/"; }
    { path = "/Applications/Google Chrome.app/"; }
    { path = "/${pkgs.vscode}/Applications/Visual Studio Code.app/"; }
    {
      path = "${config.users.users.${userData.user}.home}/Downloads";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];
}
