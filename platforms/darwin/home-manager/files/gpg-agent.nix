{pkgs, ...}: {
  ".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
      default-cache-ttl 1800
      max-cache-ttl 7200
    '';
  };
}
