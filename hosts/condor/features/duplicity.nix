{ config, pkgs, lib, ... }:
{

  # Users/Groups
  users.groups.duplicity = { };
  users.users.duplicity = {
    isNormalUser = true;
    group = "duplicity";
    shell = pkgs.zsh;
    extraGroups = [ "immich" ];
  };

  # Environment for User
  home-manager.users.duplicity = { pkgs, ... }: {
    programs = {
      gpg = {
        enable = true;
        publicKeys = [
          {
            source = config.age.secrets."duplicity.gpg".path;
            trust = 4;
          }
        ];
      };
      zsh = {
        enable = true;
      };
    };
    home.packages = with pkgs; [
      duply
      duplicity
    ];
    home.stateVersion = "24.05";
  };

  # Backup Job
  systemd.services."duplicity-immich-backup" =
    let
      configFile = pkgs.writeText "conf" ''
        source '${config.age.secrets."duplicity.env".path}'

        # GPG Options
        GPG_PW=""
        GPG_OPTS='--trust-model always --no-tty'

        # Source -> Target
        TARGET="b2://''${B2_KEY_ID}:''${B2_APPLICATION_KEY}@''${B2_BUCKET_NAME}/condor/immich"
        SOURCE='/var/immich'
      '';
      excludeFile = pkgs.writeText "exclude" "";
    in
    {
      path = [ pkgs.duply pkgs.duplicity pkgs.gnupg pkgs.coreutils ];
      script = ''
        mkdir -p /tmp/duply
        cp -f ${configFile} /tmp/duply/conf
        cp -f ${excludeFile} /tmp/duply/exclude
        duply /tmp/duply backup
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "duplicity";
        Group = "duplicity";
      };
      startAt = "*-*-* 02/6:00:00";
    };
}

