{ userData, pkgs, ... }:

let home = userData.homeDirectory pkgs; in
{
  ".config/kmonad/colemak-dh.kbd" = {
    source = ./colemak-dh.kbd;
  };

  ".config/kmonad/kmonad.service" = {
    text =
      ''
        [Unit]
        Description=Kmonad

        [Service]
        Restart=always
        RestartSec=3
        ExecStart=${pkgs.haskellPackages.kmonad}/bin/kmonad ${home}/.config/kmonad/colemak-dh.kbd
        Nice=-20

        [Install]
        DefaultInstance=config
        WantedBy=default.target
      '';
  };
}
