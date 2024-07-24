{ pkgs, ... }:

let
  major = "2";
  minor = "5";
  patch = "3";
  version = "${major}.${minor}.${patch}";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      duply = prev.duply.overrideAttrs (att: {
        inherit version;
        src = pkgs.fetchzip {
          url = "https://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/${major}.${minor}.x/duply_${version}.tgz/download";
          sha256 = "sha256-RBaVVsc/lsI6cbZyl+dEQ5d+mgKRCtXkZQTi86/OufA=";
          extension = "tar.gz";
        };
      });
    })
  ];
}
