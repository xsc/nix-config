{ pkgs, ... }:

let
  device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  config = ''
    (deflocalkeys-linux
      iso 220)

    (defsrc
      esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab     q    w    e    r    t    y    u    i    o    p    [    ]
      caps    a    s    d    f    g    h    j    k    l    ;    '    \   ret
      lsft    iso  z    x    c    v    b    n    m    ,    .    /    rsft
      lctl    lmet lalt           spc            ralt rctl
    )


    (defalias
      ext  (tap-hold 200 200 esc (layer-toggle extend))
    )


    (deflayer colemak-dhk
      esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv      1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab      q    w    f    p    b    j    l    u    y    ;    [    ]
      @ext     a    r    s    t    g    k    n    e    i    o    '    \   ret
      lsft     iso  x    c    d    v    z    m    h    ,    .    /    rsft
      lctl     lalt lmet           spc            rsft ralt
    )


    (deflayer extend
      _        _    _    _    _    _    _    _    _    _    _    _    _
      _        _    _    _    _    _    _    _    _    _    _    _    _    _
      _        _    _    _    _    _    _    _    _    _    _    del  _
      _        lctl lmet lsft lalt _    lft  down up   rght bspc _    _    _
      _    _     _    _    _    _    _    _    _  vold volu mute _
      _        _    _              ret            _    _
    )


    (deflayer empty
      _        _    _    _    _    _    _    _    _    _    _    _    _
      _        _    _    _    _    _    _    _    _    _    _    _    _    _
      _        _    _    _    _    _    _    _    _    _    _    _    _
      _        _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _     _    _    _    _    _    _    _    _    _    _    _
      _        _    _              _              _    _
    )
  '';
  configFile = pkgs.writeText "kanata-remap" ''
    (defcfg linux-dev ("${device}"))
    ${config}
  '';
  serviceCfg = {
    Type = "notify";
    ExecStart = ''
      ${pkgs.kanata}/bin/kanata \
        --cfg ${configFile} \
        --symlink-path /tmp/kanata-remap
    '';
    RuntimeDirectory = "kanata-remap";

    # hardening
    DeviceAllow = [
      "/dev/uinput rw"
      "char-input r"
    ];
    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    IPAddressDeny = [ "any" ];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    PrivateNetwork = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    SystemCallArchitectures = [ "native" ];
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
    ];
    UMask = "0077";
  };
in
{
  home-manager.users.yannick = {
    systemd.user.enable = true;
    systemd.user.services.kanata-remap = {
      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = serviceCfg;
    };
  };

  hardware.uinput.enable = true;
}
