{ config, pkgs, ... }:
let
  mkConfigFile = source: target: pkgs.writeText "conf" ''
    source '${config.age.secrets."duplicity.env".path}'

    # GPG Options
    GPG_PW=""
    GPG_OPTS='--trust-model always --no-tty'

    # Source -> Target
    TARGET="b2://''${B2_KEY_ID}:''${B2_APPLICATION_KEY}@''${B2_BUCKET_NAME}/condor/${target}"
    SOURCE='${source}'

    # Backup Options
    MAX_AGE=3M
    MAX_FULLBKP_AGE=1M
    DUPL_PARAMS="--full-if-older-than ''${MAX_FULLBKP_AGE} --allow-source-mismatch"
  '';
  excludeFile = pkgs.writeText "exclude" "";
  path = [ pkgs.duply pkgs.duplicity pkgs.gnupg pkgs.coreutils pkgs.bash ];

  mkDuplyScript = source: target: do:
    let
      configFile = mkConfigFile source target;
    in
    ''
      set -eu
      dir="/tmp/duply/${target}"
      mkdir -p $dir
      cp -f ${configFile} $dir/conf
      cp -f ${excludeFile} $dir/exclude
      ${do}
      rm -rf $dir
    '';

  mkBackupService = { source, target, startAt }: {
    inherit path startAt;
    script = mkDuplyScript source target ''
      duply $dir backup
      duply $dir purge --force
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    unitConfig = {
      OnFailure = "notify-failure@%i.service";
    };
  };

  mkVerifyService = { target, startAt }: {
    inherit path startAt;
    script = mkDuplyScript "<nothing>" target ''
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
    };

  systemd.services."duplicity-immich-backup-verify" =
    mkVerifyService {
      target = "immich";
      startAt = "*-*-01 02:00:00";
    };

  # Vaultwarden
  systemd.services."duplicity-vaultwarden-backup" =
    mkBackupService {
      source = "/var/lib/bitwarden_rs";
      target = "vaultwarden";
      startAt = "*-*-* 03:00:00";
    };
}

