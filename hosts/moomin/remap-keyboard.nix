{...}: let
  logs = "/var/log/nixos-launchd";
in {
  # remap tilde and plusminus on the internal keyboard
  launchd.agents.swapTildeAndPlusMinusOnBuildInKeyboard = {
    enable = true;
    config = {
      ProgramArguments = let
        plusminus = "30064771172";
        tilde = "30064771125";
      in [
        "/usr/bin/hidutil"
        "property"
        # matching the Karabiner Driver
        "--matching"
        ''{"ProductID": 0x27db, "VendorID": 0x16c0}''
        # swap
        "--set"
        ''
          {
            "UserKeyMapping": [
              {"HIDKeyboardModifierMappingSrc": ${tilde},"HIDKeyboardModifierMappingDst": ${plusminus}},
              {"HIDKeyboardModifierMappingSrc": ${plusminus},"HIDKeyboardModifierMappingDst": ${tilde}}
            ]
          }
        ''
      ];

      StandardOutPath = "${logs}/swapTildeAndPlusMinusOnBuildInKeyboard-stdout.log";
      StandardErrorPath = "${logs}/swapTildeAndPlusMinusOnBuildInKeyboard-stderr.log";
      RunAtLoad = true;
    };
  };
}
