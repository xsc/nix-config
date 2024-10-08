{ config, pkgs, ... }:

let user = "yannick.scherer";
    secretFile = n: {
      source = config.lib.file.mkOutOfStoreSymlink
        config.age.secrets."${n}".path;
    };
in
{
  imports = [
    ../../platforms/darwin
  ];

  # Key to decode secrets
  age.identityPaths = [ "/Users/${user}/.ssh/id_ed25519" ];

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

    home.file.".ssh/config.d/shared.ssh_config" = secretFile "shared.ssh_config";
    home.file.".ssh/config.d/moomin.ssh_config" = secretFile "moomin.ssh_config";
    home.file.".ssh/keys/id_ed25519_github" = secretFile "id_ed25519_github";
    home.file.".ssh/keys/id_ed25519_condor" = secretFile "id_ed25519_condor";
    home.file.".ssh/keys/id_rsa_moomin" = secretFile "id_rsa_moomin";
  };

}
