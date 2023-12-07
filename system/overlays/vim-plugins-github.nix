{ pkgs, ... }:

let
  vim-iced-pkg = pkgs.fetchFromGitHub {
    owner = "liquidz";
    repo = "vim-iced";
    rev = "3.14.3255";
    sha256 = "sha256-1uxpWzDzHWSXoDbD1l/A0BPX31LpSNV/S8+beO9Y/6A=";
  };
  vim-iced = pkgs.vimUtils.buildVimPlugin {
    name = "vim-iced";
    version = vim-iced-pkg.rev;
    src = vim-iced-pkg;
  };
in
(final: prev: {
  # Vim Plugins
  vimPlugins = prev.vimPlugins.extend (final': prev': { inherit vim-iced; });

  # iced-repl: REPL binary only
  iced-repl = pkgs.stdenv.mkDerivation {
    name = "iced-repl";
    version = vim-iced.version;
    src = vim-iced-pkg;

    # Patch the version directly into the script
    postBuild = ''
      sed -E -i "s/^VERSION=.+\$/VERSION=${vim-iced.version}/" bin/iced
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 bin/iced $out/bin/iced
      runHook postInstall
    '';
  };
})
