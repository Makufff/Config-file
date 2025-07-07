{ config, pkgs, ... }:

{
  networking = {
    resolvconf.dnsExtensionMechanism = false;

    nameservers = [ "10.110.192.1" ];

    networkmanager = {
      enable = true;
      dns = "none";

      settings = {
        main.dns = "none";
        ipv4."ignore-auto-dns" = true;
        ipv6."ignore-auto-dns" = true;
      };
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 53 67 80 443 ];
      allowedUDPPorts = [ 22 53 67 80 443 ];

      allowedTCPPortRanges = [ { from = 1000; to = 65535; } ];
      allowedUDPPortRanges = [ { from = 1000; to = 65535; } ];
    };
  };
}
