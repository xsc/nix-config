{ pkgs, ... }:
let
  plusminus = "30064771172";
  tilde = "30064771125";
  userKeyMapping = ''
    {
      "UserKeyMapping": [
        {"HIDKeyboardModifierMappingSrc": ${tilde},"HIDKeyboardModifierMappingDst": ${plusminus}},
        {"HIDKeyboardModifierMappingSrc": ${plusminus},"HIDKeyboardModifierMappingDst": ${tilde}}
      ]
    }
  '';
in
{
  ".bin/setup-keyboard" = {
    text = ''
      #!/bin/sh
      set -ue

      /usr/bin/hidutil property \
        --matching '{"ProductID": 0x27db, "VendorID": 0x16c0}' \
        --set '${userKeyMapping}'

      sudo ${pkgs.kanata-custom}/bin/kanata -c ${./kanata/colemak-dh.kbd}
    '';
    executable = true;
  };
}
