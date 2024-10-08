{ secrets, ... }:

let owns = { group = "agenix"; mode = "440"; };
in
{
  age.secrets."shared.ssh_config" = {
    file = "${secrets}/users/ssh_config.age";
  } // owns;

  age.secrets."credentials.clj.gpg" = {
    file = "${secrets}/users/credentials.clj.gpg.age";
  } // owns;

  users.groups."${owns.group}" = {};
}

