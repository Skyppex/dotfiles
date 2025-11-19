{pkgs}: let
  deps = [
    pkgs.alsa-lib
    pkgs.at-spi2-atk
    pkgs.at-spi2-core
    pkgs.atk
    pkgs.cairo
    pkgs.cups
    pkgs.curl
    pkgs.dbus
    pkgs.expat
    pkgs.gdk-pixbuf
    pkgs.glib
    pkgs.gtk3
    pkgs.icu
    pkgs.krb5
    pkgs.libdrm
    pkgs.libsecret
    pkgs.libuuid
    pkgs.libxcb
    pkgs.libxkbcommon
    pkgs.lttng-ust
    pkgs.libgbm
    pkgs.nspr
    pkgs.nss
    pkgs.openssl
    pkgs.pango
    pkgs.stdenv.cc.cc
    pkgs.systemd
    pkgs.xorg.libX11
    pkgs.xorg.libXScrnSaver
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXcursor
    pkgs.xorg.libXdamage
    pkgs.xorg.libXext
    pkgs.xorg.libXfixes
    pkgs.xorg.libXi
    pkgs.xorg.libXrandr
    pkgs.xorg.libXrender
    pkgs.xorg.libXtst
    pkgs.xorg.libxkbfile
    pkgs.xorg.libxshmfence
    pkgs.zlib
  ];
in
  pkgs.stdenv.mkDerivation rec {
    pname = "appgate-sdp";
    version = "6.5.3";

    src = pkgs.fetchurl {
      url = "https://bin.appgate-sdp.com/${pkgs.lib.versions.majorMinor version}/client/appgate-sdp_${version}_amd64.deb";
      sha256 = "sha256-MyC28cOTO9EpvHvlNWtdNRbuywl0uBD8G5+cACBzMRY=";
    };

    # just patch interpreter
    autoPatchelfIgnoreMissingDeps = true;
    dontConfigure = true;
    dontBuild = true;

    buildInputs = [
      pkgs.python3
      pkgs.python3.pkgs.dbus-python
    ];

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
      pkgs.dpkg
    ];

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      cp -r $out/usr/share $out/share

      substituteInPlace $out/lib/systemd/system/appgate-dumb-resolver.service \
          --replace "/opt/" "$out/opt/"

      substituteInPlace $out/lib/systemd/system/appgatedriver.service \
          --replace "/opt/" "$out/opt/" \
          --replace "InaccessiblePaths=/mnt /srv /boot /media" "InaccessiblePaths=-/mnt -/srv -/boot -/media"

      substituteInPlace $out/lib/systemd/system/appgate-resolver.service \
          --replace "/usr/sbin/dnsmasq" "${pkgs.dnsmasq}/bin/dnsmasq" \
          --replace "/opt/" "$out/opt/"

      substituteInPlace $out/opt/appgate/linux/nm.py \
          --replace "/usr/sbin/dnsmasq" "${pkgs.dnsmasq}/bin/dnsmasq"

      substituteInPlace $out/opt/appgate/linux/set_dns \
          --replace "/etc/appgate.conf" "$out/etc/appgate.conf"

      wrapProgram $out/opt/appgate/service/createdump \
          --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc ]}"

      wrapProgram $out/opt/appgate/appgate-driver \
          --prefix PATH : ${
            pkgs.lib.makeBinPath [
              pkgs.iproute2
              pkgs.networkmanager
              pkgs.dnsmasq
            ]
          } \
          --set LD_LIBRARY_PATH $out/opt/appgate/service

      # make xdg-open overrideable at runtime
      makeWrapper $out/opt/appgate/Appgate $out/bin/appgate \
          --suffix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdg-utils ]} \
          --set LD_LIBRARY_PATH $out/opt/appgate:${pkgs.lib.makeLibraryPath deps}

      wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
    '';

    meta = with pkgs.lib; {
      description = "Appgate SDP (Software Defined Perimeter) desktop client";
      homepage = "https://www.appgate.com/support/software-defined-perimeter-support";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ymatsiuk];
      mainProgram = "appgate";
    };
  }
