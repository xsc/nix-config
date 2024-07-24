{ pkgs, ... }:

let user = "yannick.scherer"; in
{
  imports = [
    ../../platforms/darwin
  ];

  users.users."${user}" = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager.users."${user}" = {
    imports = [
      ./remap-keyboard.nix
    ];

    programs.git = {
      userName = "Yannick Scherer";
      userEmail = "yannick@xsc.dev";
      signing = { key = "FCC8CDA4"; };
    };
  };

  age.identityPaths = [
    "/Users/${user}/.ssh/keys/id_ed25519_agenix"
  ];

  nix.settings.trusted-users = [ "@admin" "${user}" ];
}
