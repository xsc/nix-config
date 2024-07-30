{ pkgs, ... }:

let
  version = "1.6.1";
  kanata-pkg =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchurl
        {
          url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata_macos_arm64";
          sha256 = "sha256-6gYIItqnDAKjTCsuqF81qmvaYpYLJ5ipetKo7lXvR/Y=";
        }
    else
      pkgs.fetchurl {
        url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata";
        sha256 = "sha256-hkzVDwfbsYMHD3tRhlOXMrorcTYwra0F8GSZpb/NPmI=";
      };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      kanata = pkgs.stdenv.mkDerivation {
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
  ];
}
