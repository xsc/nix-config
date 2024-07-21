{ config, pkgs, ... }:
let
  configFile = pkgs.writeText "conf" ''
    source '${config.age.secrets."duplicity.env".path}'

    # GPG Options
    GPG_PW=""
    GPG_OPTS='--trust-model always --no-tty'

    # Source -> Target
    TARGET="b2://''${B2_KEY_ID}:''${B2_APPLICATION_KEY}@''${B2_BUCKET_NAME}/condor/immich"
    SOURCE='/var/immich'

    # Backup Options
    MAX_AGE=3M
    MAX_FULLBKP_AGE=1M
    DUPL_PARAMS="--full-if-older-than ''${MAX_FULLBKP_AGE} --allow-source-mismatch"
  '';
  excludeFile = pkgs.writeText "exclude" "";
  path = [ pkgs.duply pkgs.duplicity pkgs.gnupg pkgs.coreutils pkgs.bash ];
in
{
  systemd.services."duplicity-immich-backup" = {
    inherit path;
    script = ''
      set -eu
      mkdir -p /tmp/duply
      cp -f ${configFile} /tmp/duply/conf
      cp -f ${excludeFile} /tmp/duply/exclude
      duply /tmp/duply backup
      duply /tmp/duply purge --force
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    unitConfig = {
      OnFailure = "notify-failure@%i.service";
    };
    startAt = "*-*-* 02/6:00:00";
  };

  systemd.services."duplicity-immich-backup-verify" = {
    inherit path;
    script = ''
      set -eu
      mkdir -p /tmp/duply
      cp -f ${configFile} /tmp/duply/conf
      cp -f ${excludeFile} /tmp/duply/exclude
      duply /tmp/duply verify
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    unitConfig = {
      OnFailure = "notify-failure@%i.service";
    };
    startAt = "* *-*-01 02:00:00";
  };
}

