{ secrets, ... }:

let owns = { group = "agenix"; mode = "440"; };
in
{
  age.secrets."ssh_config" = {
    file = "${secrets}/ssh_config.age";
  } // owns;

  age.secrets."id_ed25519_github" = {
    file = "${secrets}/id_ed25519_github.age";
  } // owns;

  age.secrets."id_rsa_tado_bastion" = {
    file = "${secrets}/id_rsa_tado_bastion.age";
  } // owns;

  age.secrets."id_ed25519_contabo" = {
    file = "${secrets}/id_ed25519_contabo.age";
  } // owns;

  age.secrets."credentials.clj.gpg" = {
    file = "${secrets}/credentials.clj.gpg.age";
  } // owns;

  age.secrets."dnsmasq-nextdns.conf" = {
    file = "${secrets}/dnsmasq-nextdns.conf.age";
  } // owns;

  users.groups."${owns.group}" = {};
}

