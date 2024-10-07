{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vlc
    wireguard-tools
  ];
}
