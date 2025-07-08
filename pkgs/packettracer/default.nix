# { pkgs, ... }:

# {
#   # NOTE: MANUAL INSTALL REQUIRED FOR PACKET TRACER:
#   # log into netacad and download packet tracer for ubuntu: https://www.netacad.com/resources/lab-downloads
#   # rename downloaded file to old schema: mv Packet_Tracer822_amd64_signed.deb CiscoPacketTracer822_amd64_signed.deb
#   # add it to the nix store: nix-store --add-fixed sha256 CiscoPacketTracer822_amd64_signed.deb
#   hm.home.packages = [ pkgs.ciscoPacketTracer8 ];
# }

{ stdenv
, fetchurl
, python3
, autoPatchelfHook
, patchelf
}:

stdenv.mkDerivation rec {
  pname = "packettracer8-patched";
  version = "8.2.2";

  # เปลี่ยน path นี้เป็นไฟล์ .deb ของคุณ
  src = fetchurl {
    url = "file:///home/makufff/Downloads/CiscoPacketTracer822_amd64_signed.deb";
    sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc"; # ใส่ sha256 จริง
  };

  nativeBuildInputs = [ autoPatchelfHook patchelf python3 ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  buildPhase = ''
    chmod +w opt/pt/bin/PacketTracer

    python3 -c "
import os
with open('opt/pt/bin/PacketTracer', 'r+b') as f:
    f.seek(0x22265cb+1)
    f.write(b'\\x84')
    f.seek(0x2226920+1)
    f.write(b'\\x84')
"
  '';

  installPhase = ''
    mkdir -p $out/opt/pt
    cp -r opt/pt/* $out/opt/pt/
    ln -s $out/opt/pt/bin/PacketTracer $out/bin/packettracer
  '';

  meta = with stdenv.lib; {
    description = "Cisco Packet Tracer 8.2.2 patched to bypass isShutdown check";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.yourname ];
  };
}
