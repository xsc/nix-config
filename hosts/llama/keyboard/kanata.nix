{ pkgs, ... }:

let
  mkService = { name, defcfg, config }:
    let
      configFile = pkgs.writeText "kanata-${name}.conf" ''
        (defcfg ${defcfg})

        ${config}
      '';
    in
    {
      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "notify";
        ExecStart = ''
          ${pkgs.kanata}/bin/kanata \
            --cfg ${configFile} \
            --symlink-path /tmp/kanata-${name}
        '';
        RuntimeDirectory = "kanata-${name}";

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
    };
in
{
  hardware.uinput.enable = true;

  home-manager.users.yannick = {
    systemd.user.enable = true;

    systemd.user.services.kanata-builtin = mkService {
      # Make builtin keyboards use the Colemak-DHk layout, and map LAlt to
      # RAlt to allow access to all parts of the EurKey layout.
      name = "builtin";
      defcfg = ''
        linux-dev-names-include ("AT Translated Set 2 keyboard")
      '';
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
          ext (tap-hold 200 200 esc (layer-toggle extend))
          cmd (layer-toggle command)
          cpy C-S-c
          pst C-S-v
        )

        (deflayer colemak-dhk
          esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
          grv      1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab      q    w    f    p    b    j    l    u    y    ;    [    ]
          @ext     a    r    s    t    g    k    n    e    i    o    '    \   ret
          lsft     iso  x    c    d    v    z    m    h    ,    .    /    rsft
          lctl     ralt @cmd           spc            rsft ralt
        )

        (deflayer extend
          _        _    _    _    _    _    _    _    _    _    _    _    _
          _        _    _    _    _    _    _    _    _    _    _    _    _    _
          _        _    _    _    _    _    _    _    _    _    del  _    _
          _        lalt lmet lsft lctl _    lft  down up   rght bspc _    _    _
          _    _     _    _    _    _    _    _    _  vold volu mute _
          _        _    _              ret            _    _
        )

        (deflayer command
          _        _    _    _    _    _    _    _    _    _    _    _    _
          _        _    _    _    _    _    _    _    _    _    _    _    _    _
          A-tab    C-q  C-w  C-f  _    _    _    _    _    _    _    _    _
          _        C-a  C-r  _    C-t  _    _    _    _    _    _    _    _    _
          _        _    C-x  @cpy _    @pst _  _    _    _    _    _    _
          _        _    _              lmet           _    _
        )
      '';
    };

    systemd.user.services.kanata-others = mkService {
      # My external keyboards already have a Colemak-DHk layout, so we only
      # have to make the CMD key behave appropriately. Additionally, map LAlt
      # to RAlt to allow access to all parts of the EurKey layout, especially
      # since my external keyboards don't use Alt-Gr.
      name = "others";
      defcfg = ''
        linux-dev-names-exclude ("AT Translated Set 2 keyboard")
        process-unmapped-keys yes
      '';
      config = ''
        (defsrc
          lmet
          lalt
          spc
          bspc
          tab   q    w    r    t
                a    f
                z    x    c    v)

        (defoverrides
          (ralt bspc)  (lctl bspc)
          (ralt del)   (lctl del)
          (ralt left)  (lctl left)
          (ralt right) (lctl right))

        (defalias
          cmd   (layer-toggle command)
          cpy   C-S-c
          pst   C-S-v
        )

        (deflayer with-command
          @cmd
          ralt
          _
          _
          _     _    _    _    _
                _    _
                _    _    _    _
        )

        (deflayer command
          _
          _
          lmet
          C-S-bspc
          A-tab C-q  C-w  C-r  C-t
                C-a  C-f
                C-z  C-x  @cpy @pst
        )
      '';
    };

  };

}
