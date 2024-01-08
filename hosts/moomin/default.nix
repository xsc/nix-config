{ config, pkgs, lib, userData, theme, ... }:

let importPkg = f: import f { inherit config pkgs lib userData theme; };
in
{
  imports = [
    ../../platforms/darwin
  ];

  # User Info
  users.users."${userData.user}" = {
    name = userData.user;
    home = userData.home;
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager.users.${userData.user} = { ... }: {
    imports = [
      ./remap-keyboard.nix
    ];
  };
}
