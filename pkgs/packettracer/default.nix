{
  description = "Cisco Packet Tracer 8.2.2 patched from URL";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.ciscoPacketTracer8 = pkgs.stdenv.mkDerivation rec {
        pname = "cisco-packet-tracer";
        version = "8.2.2";

        src = pkgs.fetchurl {
          url = "https://jarukrit.net/files/KMITL/Packet_Tracer822_amd64_signed.deb";
          sha256 = "0bgplyi50m0dp1gfjgsgbh4dx2f01x44gp3gifnjqbgr3n4vilkc"; 
          # ตรวจสอบ hash ด้วยคำสั่ง nix hash เพื่อให้ถูกต้อง
        };

        nativeBuildInputs = [ pkgs.dpkg pkgs.python3 ];

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

        meta = with pkgs.lib; {
          description = "Cisco Packet Tracer 8.2.2 patched (jnz->jz fix)";
          homepage = "https://www.netacad.com/";
          license = licenses.free;
          platforms = platforms.linux;
        };
      };
    };
}
