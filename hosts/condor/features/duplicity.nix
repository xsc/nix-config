{ config, pkgs, ... }:
let
  mkConfigFile =
    { source ? "<nothing>"
    , target
    , maxAge ? "3M"
    , maxFullBackupAge ? "1M"
    , ...
    }: pkgs.writeText "conf" ''
      source '${config.age.secrets."duplicity.env".path}'

      # GPG Options
      GPG_PW=""
      GPG_OPTS='--trust-model always --no-tty'

      # Source -> Target
      TARGET="b2://''${B2_KEY_ID}:''${B2_APPLICATION_KEY}@''${B2_BUCKET_NAME}/condor/${target}"
      SOURCE='${source}'

      # Backup Options
      MAX_AGE=${maxAge}
      MAX_FULL_BACKUPS=2
      MAX_FULLBKP_AGE=${maxFullBackupAge}
      DUPL_PARAMS="--full-if-older-than ''${MAX_FULLBKP_AGE} --allow-source-mismatch"
    '';
  excludeFile = pkgs.writeText "exclude" "";
  path = [ pkgs.duply pkgs.duplicity pkgs.gnupg pkgs.coreutils pkgs.bash ];

  mkDuplyScript = { target, directoryName ? target, ... }@opts: do:
    let
      configFile = mkConfigFile opts;
    in
    ''
      set -eu
      dir="$(mktemp -d)/${directoryName}"
      mkdir -p $dir
      cp -f ${configFile} $dir/conf
      cp -f ${excludeFile} $dir/exclude
      ${do}
      rm -rf $dir
    '';

  mkBackupService = { startAt, ... }@opts: {
    inherit path startAt;
    script = mkDuplyScript opts ''
      duply $dir backup
      duply $dir purgeAuto --force
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    unitConfig = {
      OnFailure = "notify-failure@%i.service";
    };
  };

  mkVerifyService = { startAt, ... }@opts: {
    inherit path startAt;
    script = mkDuplyScript opts ''
      duply $dir verify
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    unitConfig = {
      OnFailure = "notify-failure@%i.service";
    };
  };

in
{

  # Immich
  systemd.services."duplicity-immich-backup" =
    mkBackupService {
      source = "/var/immich";
      target = "immich";
      startAt = "*-*-* 02/6:00:00";
      maxAge = "65D";
    };

  systemd.services."duplicity-immich-backup-verify" =
    mkVerifyService {
      directoryName = "immich-verify";
      target = "immich";
      startAt = "*-*-01 00:00:00";
    };

  # Vaultwarden
  systemd.services."duplicity-vaultwarden-backup" =
    mkBackupService {
      source = "/var/lib/bitwarden_rs";
      target = "vaultwarden";
      startAt = "*-*-* 00:00:00";
    };
  systemd.services."duplicity-vaultwarden-backup-verify" =
    mkVerifyService {
      target = "vaultwarden";
      startAt = "*-*-01 01:00:00";
    };

  # Gotosocial
  systemd.services."duplicity-gotosocial-backup" =
    mkBackupService {
      source = "/var/lib/gotosocial";
      target = "gotosocial";
      startAt = "Sun *-*-* 00:00:00";
    };

  systemd.services."duplicity-gotosocial-backup-verify" =
    mkVerifyService {
      target = "gotosocial";
      startAt = "*-*-01 01:00:00";
    };
}

