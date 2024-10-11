{secrets, ...}: let
  owns = {
    group = "agenix";
    mode = "440";
  };
in {
  age.secrets = {
    "moomin.ssh_config" = {file = "${secrets}/moomin/ssh_config.age";} // owns;
    "id_ed25519_github" = {file = "${secrets}/moomin/id_ed25519_github.age";} // owns;
    "id_ed25519_condor" = {file = "${secrets}/moomin/id_ed25519_condor.age";} // owns;
    "id_rsa_moomin" = {file = "${secrets}/moomin/id_rsa_moomin.age";} // owns;
    "stubby.nextdns.yml" = {file = "${secrets}/moomin/stubby.nextdns.yml.age";} // owns;
    "wireguard/condor.conf" = {file = "${secrets}/moomin/wireguard.condor.conf.age";} // owns;
  };
}
