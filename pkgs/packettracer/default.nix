{ lib, stdenv, dpkg, fetchurl }:

stdenv.mkDerivation {
  pname = "packettracer";
  version = "8.2.2";

  src = fetchurl {
    url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
    sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc";
  };

  buildInputs = [ dpkg ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $TMPDIR/unpack
    dpkg -x $src $TMPDIR/unpack

    mkdir -p $out
    cp -r $TMPDIR/unpack/* $out/

    # แก้ perm ไฟล์ให้ sandbox ผ่าน
    chmod -R u+rwX,go+rX,go-w $out

    # สร้าง .desktop file ใน $out
    mkdir -p $out/share/applications
    cat > $out/share/applications/packettracer.desktop <<EOF
[Desktop Entry]
Name=Cisco Packet Tracer
Comment=Network simulation tool
Exec=$out/usr/bin/PacketTracer
Icon=$out/usr/share/icons/hicolor/256x256/apps/packettracer.png
Terminal=false
Type=Application
Categories=Education;Network;
EOF
  '';

  meta = {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
