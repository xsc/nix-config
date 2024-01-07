{ config, pkgs, lib, userData, ... }:

{
  ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          User git
          IdentitiesOnly yes
          IdentityFile ${userData.home}/.ssh/keys/id_ed25519_github
          IdentityFile ${userData.home}/.ssh/id_ecdsa_sk # yubikey fallback
      ''
    ];
  };
}
