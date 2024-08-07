{ pkgs, ... }:

let user = "yannick.scherer"; in
{
  imports = [
    ../../platforms/darwin
  ];

  # Key to decode secrets
  age.identityPaths = [ "/Users/${user}/.ssh/keys/id_ed25519_agenix" ];

  # Theme
  theme.fontSize = 12;

  # Users
  nix.settings.trusted-users = [ "@admin" "${user}" ];

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

}
