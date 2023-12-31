{ pkgs, ... }:

let
  packages = with pkgs; [
    dockutil
    pinentry_mac
    reattach-to-user-namespace
  ];
  alfredGalleryWorkflows = with pkgs.alfredGallery; [
    emoji-search
    spotify-mini-player
  ];
  alfredCustomWorkflows = with pkgs.alfredUtils; [
    # bitwarden
    (mkAlfredWorkflow
      rec {
        name = "bitwarden";
        owner = "blacs30";
        version = "3.0.4";

        src = fetchGithubRelease {
          inherit version owner;
          repo = "bitwarden-alfred-workflow";
          hash = "sha256-05xT4pt/R4ZgAcZ1dhadU/5z/uauG7JDAOKAW4SNVxQ=";
        };
      })

    # hue
    (mkAlfredWorkflow
      rec {
        name = "hue";
        owner = "benknight";
        version = "3.1";

        src = fetchGithubRelease {
          inherit owner;
          repo = "hue-alfred-workflow";
          version = "v${version}";
          artifactName = "Philips-Hue-Controller-${version}.alfredworkflow";
          hash = "sha256-OmW6hMMNe05aYL2it3Q5oZwonZT2Rz5aOaRgtnHG/c0=";
        };
      })

    # numi-cli
    (mkAlfredWorkflow
      rec {
        name = "numi-cli";
        owner = "nikolaeu";
        version = "0.8";

        src = fetchGithubRelease {
          inherit owner;
          repo = "numi";
          version = "cli-v${version}";
          hash = "sha256-8oN2Q8sEeKqXQSotzg8ZenXSsP1bgI47Zz/+emngqbE=";
        };
      })
  ];
in
(
  packages
  ++ alfredGalleryWorkflows
  ++ alfredCustomWorkflows
)
