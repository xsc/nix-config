{ secrets, ... }:
{
  age.identityPaths = [ "/root/.ssh/keys/id_ed25519_condor" ];

  age.secrets."duplicity.gpg" = {
    file = "${secrets}/hosts/duplicity.gpg.age";
    group = "duplicity";
    mode = "440";
  };

  age.secrets."duplicity.env" = {
    file = "${secrets}/hosts/duplicity.env.age";
    group = "duplicity";
    mode = "440";
  };

  age.secrets."immich.env" = {
    file = "${secrets}/hosts/immich.env.age";
    group = "immich";
    mode = "440";
  };
}
