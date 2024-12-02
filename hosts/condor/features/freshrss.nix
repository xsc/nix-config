{config, ...}: {
  services.freshrss = {
    enable = true;
    baseUrl = "https://feeds.xsc.dev";
    virtualHost = "feeds.xsc.dev";
    passwordFile = "${config.age.secrets."freshrss.pwd".path}";
  };
}
