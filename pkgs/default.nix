# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  sddm-theme = pkgs.callPackage ./sddm-theme { };
  miru = pkgs.callPackage ./miru { };
  packettracer = pkgs.callPackage ./packettracer { };
  maschine-mikro-mk3-driver = pkgs.callPackage ./maschine-mikro-mk3-driver { };
  osu-lazer-bin-latest = pkgs.callPackage ./osu-lazer-bin-latest { };
}
