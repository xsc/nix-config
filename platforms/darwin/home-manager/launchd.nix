{ userData, ... }:

let logs = "/var/log/nixos-launchd"; in
{
  launchd.enable = true;

  # remap tilde and plusminus on the internal keyboard
  launchd.agents.swapTildeAndPlusMinusOnBuildInKeyboard = {
    enable = true;
    config = {
      ProgramArguments =
        let
          plusminus = "30064771172";
          tilde = "30064771125";
        in
        [
          "/usr/bin/hidutil"
          "property"
          "--matching"
          ''{"Product":"Apple Internal Keyboard / Trackpad"}''
          "--set"
          ''{"UserKeyMapping": [{"HIDKeyboardModifierMappingSrc": ${tilde},"HIDKeyboardModifierMappingDst": ${plusminus}},{"HIDKeyboardModifierMappingSrc": ${plusminus},"HIDKeyboardModifierMappingDst": ${tilde}}]}''
        ];

      StandardOutPath = "${logs}/swapTildeAndPlusMinusOnBuildInKeyboard-stdout.log";
      StandardErrorPath = "${logs}/swapTildeAndPlusMinusOnBuildInKeyboard-stderr.log";
      RunAtLoad = true;
    };
  };
}
