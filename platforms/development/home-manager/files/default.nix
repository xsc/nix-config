{ ageSecrets, config, ... }:

let
  secretFile = n: {
    source = config.lib.file.mkOutOfStoreSymlink
      ageSecrets."${n}".path;
  };
in
{
  imports = [
    ./lein
    ./wezterm
  ];

  home.file.".bin/release" = {
    source = ./bin/release;
    executable = true;
  };

  home.file.".bin/clojars-release" = {
    source = ./bin/clojars-release;
    executable = true;
  };

  home.file.".config/nextdns/nextdns.conf" = secretFile "nextdns.conf";
  home.file.".ssh/config.d/ssh_config" = secretFile "ssh_config";
  home.file.".ssh/keys/id_ed25519_github" = secretFile "id_ed25519_github";
  home.file.".ssh/keys/id_ed25519_contabo" = secretFile "id_ed25519_contabo";
  home.file.".ssh/keys/id_rsa_tado_bastion" = secretFile "id_rsa_tado_bastion";
}
