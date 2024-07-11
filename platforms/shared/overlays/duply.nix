{ pkgs, ... }:

let
  major = "2";
  minor = "5";
  patch = "3";
  version = "${major}.${minor}.${patch}";
  duply-pkg = pkgs.fetchzip {
    url = "https://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/${major}.${minor}.x/duply_${version}.tgz/download";
    sha256 = "sha256-RBaVVsc/lsI6cbZyl+dEQ5d+mgKRCtXkZQTi86/OufA=";
    extension = "tar.gz";
  };
in
(final: prev: {
  duply = pkgs.stdenv.mkDerivation {
    inherit version;
    name = "duply";
    src = duply-pkg;

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 $src/duply $out/bin/duply
      runHook postInstall
    '';
  };
})
