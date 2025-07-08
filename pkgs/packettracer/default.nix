{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, alsa-lib
, autoPatchelfHook
, fontconfig
, glib
, libdrm
, libglvnd
, libpulseaudio
, libudev0-shim
, libxkbcommon
, libxml2
, libxslt
, nspr
, nss
, xorg
, wayland
, wayland-protocols
, buildFHSEnvBubblewrap
}:

let
  version = "8.2.2";

  ptDrv = stdenv.mkDerivation {
    pname = "PacketTracer8Drv";
    inherit version;

    src = fetchurl {
      url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
      sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      alsa-lib
      autoPatchelfHook
      dpkg
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

  desktopFile = ''
[Desktop Entry]
Name=Cisco Packet Tracer 8
Comment=Network simulation tool from Cisco
Exec=${ptDrv}/bin/packettracer %f
Icon=${ptDrv}/opt/pt/art/app.png
Terminal=false
Type=Application
MimeType=application/x-pkt;application/x-pka;application/x-pkz;
Categories=Education;Network;
'';

  fhsEnv = buildFHSEnvBubblewrap {
    name = "packettracer8";
    runScript = "${ptDrv}/bin/packettracer";
    targetPkgs = pkgs: [
      libudev0-shim
    ];

    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      echo "${desktopFile}" > "$out/share/applications/cisco-pt8.desktop"
      mkdir -p "$out/share/icons/hicolor/256x256/apps"
      cp ${ptDrv}/opt/pt/art/app.png "$out/share/icons/hicolor/256x256/apps/app.png"
    '';
  };

in stdenv.mkDerivation {
  pname = "ciscoPacketTracer8";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ln -s ${fhsEnv} $out
  '';

  meta = with lib; {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = licenses.unfree;
    maintainers = with maintainers; [ lucasew ];
    platforms = [ "x86_64-linux" ];
  };
}
