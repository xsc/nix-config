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
  everforest-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "everforest-nvim";
    version = "eedb19079c6bf9d162f74a5c48a6d2759f38cc76";
    src = pkgs.fetchFromGitHub {
      owner = "neanias";
      repo = "everforest-nvim";
      rev = "eedb19079c6bf9d162f74a5c48a6d2759f38cc76";
      sha256 = "sha256-/k6VBzXuap8FTqMij7EQCh32TWaDPR9vAvEHw20fMCo=";
    };
  };
in
(final: prev: {
  # Vim Plugins
  vimPlugins = prev.vimPlugins.extend (final': prev': {
    inherit vim-iced everforest-nvim;
  });

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
