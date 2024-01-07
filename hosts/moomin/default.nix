{ agenix, alfred, userData, pkgs, ... }:

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
}
