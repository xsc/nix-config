{ pkgs, config, lib, ... }:

{
  ".lein/profiles.clj" = {
    source = ./config/lein/profiles.clj;
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

  # EurKEY
  "Library/Keyboard Layouts/EurKEY.icns" = {
    source = ./config/eurkey/EurKEY.icns;
  };

  "Library/Keyboard Layouts/EurKEY.keylayout" = {
    source = ./config/eurkey/EurKEY.keylayout;
  };
}
