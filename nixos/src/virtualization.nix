{
	pkgs,
	...
} : {
  virtualisation.libvirtd = {
	  enable = true;
	  qemu = {
		ovmf.enable = true;
		ovmf.packages = [
			pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
			pkgs.OVMF.fd
		];
	  };
  };
 #  virtualisation.virtualbox = {
	# host = {
	# 	enable = true;
	# 	enableExtensionPack = true;
	# };
 #  };
	virtualisation.docker.extraOptions = "--dns 8.8.8.8 --dns 1.1.1.1";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # virtualisation.docker = {
  #   enable = true;
  #   # storageDriver = "btrfs";
  # };
  virtualisation.waydroid.enable = true;
}
