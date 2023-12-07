{ pkgs, config, lib, ... }:

let
  eurkey = pkgs.fetchFromGitHub {
    owner = "xsc";
    repo = "eurkey-mac";
    rev = "498a7203309d1cfdb3a81960edc812c38fd8acf3";
    sha256 = "sha256-/Tmm9dkE1HILryzQ9e6or+Z9geCzS5yZ8GLN3ak22pU=";
  };
in
{
  ".lein/profiles.clj" = { source = ./lein/profiles.clj; };

  ".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
      default-cache-ttl 1800
      max-cache-ttl 7200
    '';
  };

  # Karabiner
  ".config/karabiner" = { source = ./karabiner; };

  # EurKEY
  "Library/Keyboard Layouts/EurKEY.icns" = { source = eurkey + /EurKEY.icns; };

  "Library/Keyboard Layouts/EurKEY.keylayout" = {
    source = eurkey + /EurKEY.keylayout;
  };
}
