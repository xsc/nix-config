{
  config,
  pkgs,
  ...
}: {
  imports = [./options.nix];

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    {path = "/Applications/Firefox.app/";}
    {path = "/${pkgs.wezterm}/Applications/WezTerm.app/";}
    {path = "/Applications/Google Chrome.app/";}
    {path = "/Applications/Bruno.app/";}
    {
      path = "~/Downloads";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];
}
