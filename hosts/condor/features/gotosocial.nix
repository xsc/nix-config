{ ... }:

{
  services.gotosocial = {
    enable = true;
    settings = {
      # Base Settings
      application-name = "social.xsc.dev";
      host = "social.xsc.dev";
      protocol = "https";
      bind-address = "127.0.0.1";
      port = 2286;

      # Instance
      instance-languages = [ "en" "de" ];
    };
  };
}

