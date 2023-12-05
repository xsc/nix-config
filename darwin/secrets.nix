{ config, pkgs, agenix, secrets, ... }:

let user = "yannick.scherer@futurice.com"; in
{
  age.identityPaths = [
    "/Users/${user}/.ssh/keys/id_ed25519_agenix"
  ];

  age.secrets."id_ed25519_github" = {
    symlink = true;
    path = "/Users/${user}/.ssh/keys/id_ed25519_github";
    file =  "${secrets}/id_ed25519_github.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

  age.secrets."credentials.clj.gpg" = {
    symlink = true;
    path = "/Users/${user}/.lein/credentials.clj.gpg";
    file =  "${secrets}/credentials.clj.gpg.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

}
