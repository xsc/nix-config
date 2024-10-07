{ secrets, ... }:
{
  age.identityPaths = [ "/root/.ssh/keys/id_ed25519_condor" ];

  age.secrets."duplicity.gpg" = {
    file = "${secrets}/hosts/duplicity.gpg.age";
    mode = "400";
  };

  age.secrets."duplicity.env" = {
    file = "${secrets}/hosts/duplicity.env.age";
    mode = "400";
  };

  age.secrets."immich.env" = {
    file = "${secrets}/hosts/immich.env.age";
    group = "immich";
    mode = "440";
  };

  age.secrets."acme.env" = {
    file = "${secrets}/hosts/acme.condor.env.age";
    group = "nginx";
    mode = "440";
  };

  age.secrets."cloudflared.json" = {
    file = "${secrets}/hosts/cloudflared.condor.age";
    group = "cloudflared";
    mode = "440";
  };

  age.secrets."smtp2go.pwd" = {
    file = "${secrets}/hosts/smtp2go.condor.age";
    group = "msmtp";
    mode = "440";
  };

  age.secrets."vaultwarden.env" = {
    file = "${secrets}/hosts/vaultwarden.env.age";
    mode = "400";
  };

  age.secrets."wireguard.key" = {
    file = "${secrets}/hosts/wireguard.condor.key.age";
    mode = "440";
  };
}
