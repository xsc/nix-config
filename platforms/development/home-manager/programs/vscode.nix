{ pkgs, theme, ... }:

let T = theme.vscode;
in {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    package = pkgs.vscode;

    extensions = with pkgs.vscode-marketplace; [
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers

      pkgs.vscode-marketplace.${T.colorscheme.publisher}.${T.colorscheme.plugin}
    ];

    userSettings = {
      "editor.fontFamily" = "${T.font.fontFamily}";
      "editor.fontLigatures" = true;
      "editor.fontSize" = T.font.fontSize;
      "editor.fontWeight" = "normal";
      "extensions.ignoreRecommendations" = true;

      # Theme
      "workbench.colorTheme" = T.colorscheme.name;
    } // T.colorscheme.settings;
  };
}
