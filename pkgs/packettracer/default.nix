{ lib
, stdenv
, dpkg
, python3
}:

stdenv.mkDerivation rec {
  pname = "cisco-packet-tracer";
  version = "8.2.2";

  # ให้ใส่ path nix store ที่ได้จาก nix-store --add-fixed
  src = /nix/store/6hjgf7b5vg9nqa4hl150pxdcs8xf4i15-CiscoPacketTracer822_amd64_signed.deb;

  nativeBuildInputs = [ dpkg python3 ];

  unpackPhase = ''
    mkdir unpack
    dpkg-deb -x $src unpack
    dpkg-deb --control $src unpack/DEBIAN
  '';

  buildPhase = ''
    python3 - <<EOF
import os

FIRST_JNZ_CHECK = 0x22265cb + 1
SECOND_JNZ_CHECK = 0x2226920 + 1

binary_path = "unpack/usr/local/bin/PacketTracer"

with open(binary_path, "r+b") as f:
    f.seek(FIRST_JNZ_CHECK)
    f.write(b"\\x84")
    f.seek(SECOND_JNZ_CHECK)
    f.write(b"\\x84")
EOF
  '';

  installPhase = ''
    mkdir -p $out
    cp -r unpack/* $out/
  '';

  meta = with lib; {
    description = "Cisco Packet Tracer ${version} patched";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.free;
  };
}
