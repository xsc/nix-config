{pkgs, ...}: let
  user = "yannick.scherer";
in {
  imports = [
    ../../platforms/darwin
    ./secrets.nix
  ];

  # Key to decode secrets
  age.identityPaths = ["/Users/${user}/.ssh/id_ed25519"];

  # Theme
  theme.fontSize = 12;

  # Users
  nix.settings.trusted-users = ["@admin" "${user}"];

  users.users."${user}" = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager.users."${user}" = {
    ageSecrets,
    config,
    ...
  }: let
    secretFile = n: {
      source =
        config.lib.file.mkOutOfStoreSymlink
        ageSecrets."${n}".path;
    };
  in {
    imports = [
      ./remap-keyboard.nix
    ];

    programs.git = {
      userName = "Yannick Scherer";
      userEmail = "yannick@xsc.dev";
      signing = {key = "FCC8CDA4";};
    };

    programs.zsh.shellAliases = {
      wgu = "sudo wg-quick up ${ageSecrets."wireguard.condor.conf".path}";
      wgd = "sudo wg-quick down ${ageSecrets."wireguard.condor.conf".path}";
      dns = "sudo networksetup -setdnsservers Wi-Fi";
      dns-reset = "sudo networksetup -setdnsservers Wi-Fi 127.0.0.1";
    };

    home.file.".ssh/config.d/shared.ssh_config" = secretFile "shared.ssh_config";
    home.file.".ssh/config.d/moomin.ssh_config" = secretFile "moomin.ssh_config";
    home.file.".ssh/keys/id_ed25519_github" = secretFile "id_ed25519_github";
    home.file.".ssh/keys/id_ed25519_condor" = secretFile "id_ed25519_condor";
    home.file.".ssh/keys/id_rsa_moomin" = secretFile "id_rsa_moomin";
  };
}
