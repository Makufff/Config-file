{ lib, stdenv }:

stdenv.mkDerivation {
  pname = "packettracer";
  version = "8.2.2";

  src = /nix/store/6562jz9mm4cika220bjxhbh42chp33hr-Packet_Tracer822_amd64_signed.deb;

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  meta = {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
