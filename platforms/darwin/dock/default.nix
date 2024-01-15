{ config, pkgs, userData, ... }:

{
  imports = [ ./options.nix ];

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Firefox.app/"; }
    { path = "/${pkgs.wezterm}/Applications/WezTerm.app/"; }
    { path = "/Applications/Google Chrome.app/"; }
    { path = "/Applications/IntelliJ IDEA.app/"; }
    {
      path = "${config.users.users.${userData.user}.home}/Downloads";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];
}
