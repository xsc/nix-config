{ pkgs, ... }:

{
  imports = [
    ../../platforms/darwin
  ];

  users.users."yannick.scherer" = {
    name = "yannick.scherer";
    home = "/Users/yannick.scherer";
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager.users."yannick.scherer" = {
    imports = [
      ./remap-keyboard.nix
    ];

    programs.git = {
      userName = "Yannick Scherer";
      userEmail = "yannick@xsc.dev";
      signing = { key = "FCC8CDA4"; };
    };
  };

  age.identityPaths = [
    "/Users/yannick.scherer/.ssh/keys/id_ed25519_agenix"
  ];
}
