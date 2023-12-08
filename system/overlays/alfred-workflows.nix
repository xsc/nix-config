{ pkgs, ... }:

let
  # --- Package Logic
  fetchPackal = { bundle, name, hash }: pkgs.fetchurl {
    inherit hash;
    url = "https://github.com/packal/repository/raw/master/${bundle}/${name}.alfredworkflow";
  };

  fetchGithubRelease = { owner, repo, version, artifactName ? null, hash }:
    let
      filename =
        if artifactName == null
        then "${repo}.alfredworkflow"
        else artifactName;
    in
    pkgs.fetchurl {
      inherit hash;
      url =
        "https://github.com/${owner}/${repo}/releases/download/${version}/${filename}";
    };

  mkAlfredWorkflow = { name, version, src }:
    pkgs.stdenv.mkDerivation {
      inherit name version src;

      unpackPhase = ''
        runHook preUnpack
        cp $src/*.alfredworkflow "${name}.alfredworkflow" || \
          cp $src "${name}.alfredworkflow"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/alfred-workflows
        install -Dm644 ${name}.alfredworkflow $out/share/alfred-workflows
        runHook postInstall
      '';
    };

  # --- Workflows
  workflows = {
    bitwarden = mkAlfredWorkflow rec {
      name = "bitwarden";
      version = "3.0.4";

      src = fetchGithubRelease {
        inherit version;
        owner = "blacs30";
        repo = "bitwarden-alfred-workflow";
        hash = "sha256-05xT4pt/R4ZgAcZ1dhadU/5z/uauG7JDAOKAW4SNVxQ=";
      };
    };

    # https://github.com/benknight/hue-alfred-workflow/releases/download/v3.1/Philips-Hue-Controller-3.1.alfredworkflow
    hue = mkAlfredWorkflow
      rec {
        name = "hue";
        version = "3.1";

        src = fetchGithubRelease {
          owner = "benknight";
          repo = "hue-alfred-workflow";
          version = "v${version}";
          artifactName = "Philips-Hue-Controller-${version}.alfredworkflow";
          hash = "sha256-OmW6hMMNe05aYL2it3Q5oZwonZT2Rz5aOaRgtnHG/c0=";
        };
      };

    numi-cli = mkAlfredWorkflow
      rec {
        name = "numi-cli";
        version = "0.8";

        src = fetchGithubRelease {
          owner = "nikolaeu";
          repo = "numi";
          version = "cli-v${version}";
          hash = "sha256-8oN2Q8sEeKqXQSotzg8ZenXSsP1bgI47Zz/+emngqbE=";
        };
      };

    spotify-mini-player = mkAlfredWorkflow
      rec {
        name = "spotify-mini-player";
        version = "13.2";

        src = fetchGithubRelease {
          owner = "vdesabou";
          repo = "alfred-spotify-mini-player";
          version = "v-${version}";
          artifactName = "spotifyminiplayer.alfredworkflow";
          hash = "sha256-6j4kgZS9tu/iBNbcXFAhbVoNhgejFysI6o4GKgLWhmc=";
        };
      };


  };
  # ---
in
(final: prev: {
  alfredWorkflows =
    if (prev ? alfredWorkflows)
    then
      prev.alfredWorkflows.extend (final': prev': workflows)
    else
      workflows;
})
