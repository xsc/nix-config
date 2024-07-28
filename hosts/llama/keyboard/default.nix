{ ... }:

{
  imports = [
    ./kanata.nix
  ];

  services.xserver.xkb.layout = "eu";
  console.keyMap = "us";
}
