{ lib, pkgs, secrets, userData, ... }:

let home = userData.homeDirectory;
in
{
  age.identityPaths = [ "${home}/.ssh/keys/id_ed25519_agenix" ];

  age.secrets."id_ed25519_github" = {
    symlink = true;
    path = "${home}/.ssh/keys/id_ed25519_github";
    file = "${secrets}/id_ed25519_github.age";
    mode = "600";
  };

  age.secrets."credentials.clj.gpg" = {
    symlink = true;
    path = "${home}/.lein/credentials.clj.gpg";
    file = "${secrets}/credentials.clj.gpg.age";
    mode = "600";
  };

  age.secrets."nextdns.conf" = {
    path = "${home}/.config/nextdns/nextdns.conf";
    file = "${secrets}/nextdns.conf.age";
    mode = "600";
  };

}
