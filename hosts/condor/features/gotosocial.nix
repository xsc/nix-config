{pkgs, ...}: let
  owner = "superseriousbusiness";
  repo = "gotosocial";
  version = "0.17.0-rc3";
  web-assets = pkgs.fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-Uwltr5syOnDZOgMc2L/iedxiMMKXmULzm0SAs3W0SXQ=";
  };
  rcPackage = pkgs.gotosocial.overrideAttrs (old: {
    inherit version;

    src = pkgs.fetchFromGitHub {
      inherit owner repo;
      rev = "refs/tags/v${version}";
      hash = "sha256-tI5q29VWgjR5iySbf3Z8e3IgzruhBL4s5NaXwm5zwvA=";
    };

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    postInstall = ''
      tar xf ${web-assets}
      mkdir -p $out/share/gotosocial
      mv web $out/share/gotosocial/
    '';
  });
in {
  services.gotosocial = {
    enable = true;
    package = rcPackage;
    settings = {
      # Base Settings
      application-name = "social.xsc.dev";
      host = "social.xsc.dev";
      protocol = "https";
      bind-address = "127.0.0.1";
      port = 2286;

      # Instance
      instance-languages = ["en" "de"];
    };
  };

  services.fail2ban.jails."gotosocial".settings = {
    enabled = true;
    filter = "gotosocial";
    action = "action-ban-gotosocial";
    maxretry = 3;
    findtime = 300;
    bantime = "24h";
    journalmatch = "_SYSTEMD_UNIT=gotosocial.service";
  };

  environment.etc = {
    "fail2ban/filter.d/gotosocial.conf".text = ''
      [Definition]
      failregex = ^.*statusCode=401 path=/auth/sign_in clientIP=<ADDR> .* msg=\"Unauthorized:.*$
      ignoreregex =
    '';

    "fail2ban/action.d/action-ban-gotosocial.conf".text = ''
      [Definition]
      actionban = iptables -I INPUT -p tcp --dport 2286 -m string --algo bm --string 'X-Forwarded-For: <ip>' -j DROP
      actionunban = iptables -D INPUT -p tcp --dport 2286 -m string --algo bm --string 'X-Forwarded-For: <ip>' -j DROP
    '';
  };
}
