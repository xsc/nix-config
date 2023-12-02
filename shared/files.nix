{ pkgs, config, lib, ... }:

{
  ".lein/profiles.clj" = {
    text = lib.fileContents ./config/lein/profiles.clj;
  };

  ".gnupg/gpg-agent.conf" = {
    text =
      ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
      default-cache-ttl 1800
      max-cache-ttl 7200
      '';
  };

  # Karabiner
  ".config/karabiner" = {
    source = ./config/karabiner;
  };

}
