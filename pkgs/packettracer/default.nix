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
    mkdir -p $out/usr/bin
    dpkg -x $src $out
    mkdir -p $out/share/applications
    cat > $out/share/applications/packettracer.desktop <<EOF
  [Desktop Entry]
  Name=Cisco Packet Tracer
  Exec=$out/usr/bin/PacketTracer
  Icon=$out/usr/share/icons/packettracer.png
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
