{ ... }:

{
  imports = [
    ./kanata.nix
  ];

  services.xserver.xkb.layout = "de,eu";
  console.keyMap = "us";
}
