{ ... }:
{
  # Base Settings
  services.nginx = {
    enable = true;

    # Recommended Settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Special Settings
    clientMaxBodySize = "750m";
  };

  # Security Settings
  security.acme = {
    acceptTerms = true;
    defaults.email = "infra@xsc.dev";
  };
}
