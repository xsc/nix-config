{...}: {
  services.hedgedoc = {
    enable = true;
    settings = {
      protocolUseSSL = true;
      domain = "md.xsc.dev";

      host = "127.0.0.1";
      port = 2284;

      allowEmailRegister = true;
      allowAnonymous = true;
    };
  };
}
