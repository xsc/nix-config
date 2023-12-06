{ config, pkgs, lib, userData, ... }:

{
  vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    package = pkgs.vscode;

    extensions = with pkgs.vscode-marketplace; [
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers
    ];

    userSettings = {
      "editor.fontFamily" = "'FiraCode Nerd Font', 'Fira Code'";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 12;
      "editor.fontWeight" = "normal";
      "extensions.showRecommendationsOnlyOnDemand" = true;
      "extensions.ignoreRecommendations" = true;
    };
  };
}
