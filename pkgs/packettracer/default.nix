{ lib, stdenv, fetchurl, dpkg, qt5 }:

stdenv.mkDerivation {
  pname = "packettracer";
  version = "8.2.2";

  src = fetchurl {
    url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
    sha256 = "0v9m4lk4yjq1b0axl4zj74j7p3vvsqkjd2w13gsbnr91b84p1k76";
  };

  buildInputs = [ dpkg qt5.qtbase qt5.qtnetworkauth ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $TMPDIR/unpack
    dpkg -x $src $TMPDIR/unpack

    mkdir -p $out
    cp -r $TMPDIR/unpack/* $out/

    chmod -R u+rwX,go+rX,go-w $out

    mkdir -p $out/bin
    cat > $out/bin/packettracer <<EOF
#!/usr/bin/env bash
exec $out/opt/pt/bin/PacketTracer7 "\$@"
EOF
    chmod +x $out/bin/packettracer

    mkdir -p $out/share/applications
    cat > $out/share/applications/packettracer.desktop <<EOF
[Desktop Entry]
Name=Cisco Packet Tracer
Comment=Network simulation tool
Exec=$out/bin/packettracer
Icon=$out/opt/art/app.png
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
