{ pkgs, secrets, userData, ... }:

let
  user = userData.user;
  home = userData.home;
  owns =
    if pkgs.stdenv.isDarwin then {
      owner = "${user}";
      group = "staff";
    } else { };

in
{
  age.identityPaths = [ "${home}/.ssh/keys/id_ed25519_agenix" ];

  age.secrets."ssh_config" = {
    symlink = true;
    path = "${home}/.ssh/config.d/ssh_config";
    file = "${secrets}/ssh_config.age";
    mode = "600";
  } // owns;

  age.secrets."id_ed25519_github" = {
    symlink = true;
    path = "${home}/.ssh/keys/id_ed25519_github";
    file = "${secrets}/id_ed25519_github.age";
    mode = "600";
  } // owns;

  age.secrets."id_rsa_tado_bastion" = {
    symlink = true;
    path = "${home}/.ssh/keys/id_rsa_tado_bastion";
    file = "${secrets}/id_rsa_tado_bastion.age";
    mode = "600";
  } // owns;

  age.secrets."credentials.clj.gpg" = {
    symlink = true;
    path = "${home}/.lein/credentials.clj.gpg";
    file = "${secrets}/credentials.clj.gpg.age";
    mode = "600";
  } // owns;

  age.secrets."nextdns.conf" = {
    path = "${home}/.config/nextdns/nextdns.conf";
    file = "${secrets}/nextdns.conf.age";
    symlink = false;
    mode = "600";
  } // owns;

}
