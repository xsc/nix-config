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
  };
}
