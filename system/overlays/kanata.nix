{ pkgs, ... }:

let
  version = "1.5.0";
  kanata-pkg =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchurl
        {
          url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata_macos";
          sha256 = "sha256-asJp7wh0ihL4rUcm0YzDYhZNLUJ5WLwKLCS0qKyNIls=";
        }
    else
      pkgs.fetchurl {
        url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata";
        sha256 = "sha256-hkzVDwfbsYMHD3tRhlOXMrorcTYwra0F8GSZpb/NPmI=";
      };
in
(final: prev: {
  kanata-custom = pkgs.stdenv.mkDerivation {
    inherit version;
    name = "kanata-custom";
    src = kanata-pkg;

    dontUnpack = true;
    dontFixup = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 $src $out/bin/kanata
      runHook postInstall
    '';
  };
})
