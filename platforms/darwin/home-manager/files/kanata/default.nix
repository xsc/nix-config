{pkgs, ...}: let
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
  setupScript = pkgs.writeShellScript "setup-keyboard" ''
    /usr/bin/hidutil property \
      --matching '{"ProductID": 0x27db, "VendorID": 0x16c0}' \
      --set '${userKeyMapping}'

    sudo ${pkgs.kanata}/bin/kanata -c ${./colemak-dh.kbd}
  '';
in {
  home.file = {
    ".config/kanata/colemak-dh.kbd" = {
      source = ./colemak-dh.kbd;
    };

    ".bin/setup-keyboard" = {
      source = setupScript;
      executable = true;
    };
  };
}
