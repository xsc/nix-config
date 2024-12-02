{secrets, ...}: {
  age = {
    identityPaths = ["/root/.ssh/keys/id_ed25519_condor"];

    secrets = {
      "duplicity.gpg" = {
        file = "${secrets}/shared/duplicity.gpg.age";
        mode = "400";
      };

      "duplicity.env" = {
        file = "${secrets}/shared/duplicity.env.age";
        mode = "400";
      };

      "immich.env" = {
        file = "${secrets}/condor/immich.env.age";
        group = "immich";
        mode = "440";
      };

      "acme.env" = {
        file = "${secrets}/condor/acme.env.age";
        group = "nginx";
        mode = "440";
      };

      "freshrss.pwd" = {
        file = "${secrets}/condor/freshrss.pwd.age";
        group = "freshrss";
        mode = "440";
      };

      "cloudflared.json" = {
        file = "${secrets}/condor/cloudflared.json.age";
        group = "cloudflared";
        mode = "440";
      };

      "smtp2go.pwd" = {
        file = "${secrets}/condor/smtp2go.key.age";
        group = "msmtp";
        mode = "440";
      };

      "vaultwarden.env" = {
        file = "${secrets}/condor/vaultwarden.env.age";
        mode = "400";
      };

      "wireguard.key" = {
        file = "${secrets}/condor/wireguard.key.age";
        mode = "440";
      };
    };
  };
}
