{ stdenv
, lib
, alsa-lib
, autoPatchelfHook
, buildFHSEnvBubblewrap
, dpkg
, expat
, fetchurl
, fontconfig
, glib
, libdrm
, libglvnd
, libpulseaudio
, libudev0-shim
, libxkbcommon
, libxml2
, libxslt
, lndir
, makeWrapper
, nspr
, nss
, xorg
, wayland
, wayland-protocols
, copyDesktopItems
}:

let
  version = "8.2.2";

  ptFiles = stdenv.mkDerivation {
    pname = "PacketTracer8Drv";
    inherit version;

    dontUnpack = true;
    src = fetchurl {
      url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
      sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc";
    };

    nativeBuildInputs = [
      alsa-lib
      autoPatchelfHook
      dpkg
      expat
      fontconfig
      glib
      libdrm
      libglvnd
      libpulseaudio
      libudev0-shim
      libxkbcommon
      libxml2
      libxslt
      makeWrapper
      nspr
      nss
      wayland
      wayland-protocols
    ] ++ (with xorg; [
      libICE
      libSM
      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXScrnSaver
      libXtst
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ]);

    installPhase = ''
      dpkg-deb -x $src $out
      chmod 755 "$out"
      makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer" \
        --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"
      ln -s $src $out/usr/share/
    '';
  };

  desktopItemPath = stdenv.mkDerivation {
    name = "cisco-packettracer-desktop";
    buildCommand = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/cisco-pt8.desktop <<EOF
[Desktop Entry]
Name=Cisco Packet Tracer 8
Comment=Network simulation tool from Cisco
Exec=packettracer %f
Icon=${ptFiles}/opt/pt/art/app.png
Terminal=false
Type=Application
MimeType=application/x-pkt;application/x-pka;application/x-pkz;
Categories=Education;Network;
EOF
    '';
  };

  fhs = buildFHSEnvBubblewrap {
    name = "packettracer8";
    runScript = "${ptFiles}/bin/packettracer";
    targetPkgs = pkgs: [
      libudev0-shim
    ];

    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      cp -r ${desktopItemPath}/share/applications/* "$out/share/applications/"
    '';
  };

  # derivation หลัก
in stdenv.mkDerivation {
  pname = "ciscoPacketTracer8";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems lndir ];

  installPhase = ''
    mkdir -p $out
    ${lndir}/bin/lndir -silent ${fhs} $out
  '';

  desktopItems = [ desktopItemPath ];

  meta = with lib; {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = licenses.unfree;
    maintainers = with maintainers; [ lucasew ];
    platforms = [ "x86_64-linux" ];
  };
}
