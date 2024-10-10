{secrets, ...}: let
  owns = {
    group = "agenix";
    mode = "440";
  };
in {
  age.secrets."llama.ssh_config" =
    {
      file = "${secrets}/llama/ssh_config.age";
    }
    // owns;

  age.secrets."id_ed25519_github" =
    {
      file = "${secrets}/llama/id_ed25519_github.age";
    }
    // owns;

  age.secrets."id_ed25519_condor" =
    {
      file = "${secrets}/llama/id_ed25519_condor.age";
    }
    // owns;

  age.secrets."stubby.nextdns.yml" = {
    file = "${secrets}/llama/stubby.nextdns.yml.age";
    group = "stubby";
    mode = "440";
  };

  age.secrets."wireguard.condor.conf" =
    {
      name = "wireguard/condor.conf";
      file = "${secrets}/llama/wireguard.condor.conf.age";
    }
    // owns;
}
