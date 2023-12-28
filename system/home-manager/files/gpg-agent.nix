{ pkgs, ... }:

{
  ".gnupg/gpg-agent.conf" =
    let
      pinentry =
        if pkgs.stdenv.isDarwin then
          "${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}"
        else
          "${pkgs.pinentry-curses}/bin/pinentry-curses";
    in
    {
      text = ''
        pinentry-program ${pinentry}
        default-cache-ttl 1800
        max-cache-ttl 7200
      '';
    };
}
