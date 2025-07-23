{
  ...
} : {
  networking.resolvconf.dnsExtensionMechanism = false;
  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
    firewall = {
      allowedTCPPorts = [ 22 53 67 80 443 ];
      allowedUDPPorts = [ 22 53 67 80 443 ];
      allowedTCPPortRanges = [
        { from = 1000; to = 65535; }
    ];
     allowedUDPPortRanges = [
       { from = 1000; to = 65535; }
     ];
     enable = true;
	};
    resolvconf.enable = false;
  };
  services.resolved.enable = false;
}
