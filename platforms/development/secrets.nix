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

  age.secrets."dnsmasq-nextdns.conf" = {
    file = "${secrets}/users/dnsmasq-nextdns.conf.age";
  } // owns;

  users.groups."${owns.group}" = {};
}

