{ lib, stdenv, fetchurl, dpkg, qt5 }:

stdenv.mkDerivation {
  pname = "packettracer";
  version = "8.2.2";

  src = fetchurl {
    url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
    sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc";
  };

  buildInputs = [
    dpkg
    qt5.qtbase
    qt5.qtnetworkauth
    qt5.qttools
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $TMPDIR/unpack
    dpkg -x $src $TMPDIR/unpack

    mkdir -p $out/opt
    cp -r $TMPDIR/unpack/opt/pt $out/opt/

    chmod -R u+rwX,go+rX,go-w $out/opt/pt

    mkdir -p $out/bin

    wrapQtAppsHook

    wrapProgram $out/opt/pt/bin/PacketTracer \
      --prefix LD_LIBRARY_PATH : \
        ${qt5.qtbase}/lib:\
        ${qt5.qtnetworkauth}/lib:\
        ${qt5.qttools}/lib:\
        $out/opt/pt/lib

    ln -s $out/opt/pt/bin/PacketTracer $out/bin/packettracer

    mkdir -p $out/share/applications
    cat > $out/share/applications/packettracer.desktop <<EOF
[Desktop Entry]
Name=Cisco Packet Tracer
Comment=Network simulation tool
Exec=$out/bin/packettracer
Icon=$out/opt/pt/art/app.png
Terminal=false
Type=Application
Categories=Education;Network;
EOF
  '';

  meta = with lib; {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
