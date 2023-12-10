{ secrets, userData, ... }:

let user = userData.user;
in {
  age.identityPaths = [ "/Users/${user}/.ssh/keys/id_ed25519_agenix" ];

  age.secrets."id_ed25519_github" = {
    symlink = true;
    path = "/Users/${user}/.ssh/keys/id_ed25519_github";
    file = "${secrets}/id_ed25519_github.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

  age.secrets."credentials.clj.gpg" = {
    symlink = true;
    path = "/Users/${user}/.lein/credentials.clj.gpg";
    file = "${secrets}/credentials.clj.gpg.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

  age.secrets."nextdns.conf" = {
    path = "/Users/${user}/.config/nextdns/nextdns.conf";
    file = "${secrets}/nextdns.conf.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

}
