{ config, pkgs, lib, userData, ... }:

let home = userData.homeDirectory pkgs; in
{
  ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          User git
          IdentitiesOnly yes
          IdentityFile ${home}/.ssh/keys/id_ed25519_github
          IdentityFile ${home}/.ssh/id_ecdsa_sk # yubikey fallback
      ''
    ];
  };
}
