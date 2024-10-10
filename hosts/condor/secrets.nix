{secrets, ...}: {
  age.identityPaths = ["/root/.ssh/keys/id_ed25519_condor"];

  age.secrets."duplicity.gpg" = {
    file = "${secrets}/shared/duplicity.gpg.age";
    mode = "400";
  };

  age.secrets."duplicity.env" = {
    file = "${secrets}/shared/duplicity.env.age";
    mode = "400";
  };

  age.secrets."immich.env" = {
    file = "${secrets}/condor/immich.env.age";
    group = "immich";
    mode = "440";
  };

  age.secrets."acme.env" = {
    file = "${secrets}/condor/acme.env.age";
    group = "nginx";
    mode = "440";
  };

  age.secrets."cloudflared.json" = {
    file = "${secrets}/condor/cloudflared.json.age";
    group = "cloudflared";
    mode = "440";
  };

  age.secrets."smtp2go.pwd" = {
    file = "${secrets}/condor/smtp2go.key.age";
    group = "msmtp";
    mode = "440";
  };

  age.secrets."vaultwarden.env" = {
    file = "${secrets}/condor/vaultwarden.env.age";
    mode = "400";
  };

  age.secrets."wireguard.key" = {
    file = "${secrets}/condor/wireguard.key.age";
    mode = "440";
  };
}
