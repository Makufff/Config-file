{
  ...
} : {
  # networking.resolvconf.dnsExtensionMechanism = false;
  networking = {

    networkmanager = {
      enable = true;
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
  };
}
