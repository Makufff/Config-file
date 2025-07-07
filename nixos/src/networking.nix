{ ... }:

{
  networking = {
    # ตั้ง DNS ให้ชี้ไปที่ FortiGate (Gateway) ชั่วคราว
    # แก้ให้เป็น IP Gateway ของคุณ เช่น 10.110.192.1
    nameservers = [ "10.110.192.1" ];

    # ใช้ NetworkManager จัดการเน็ตเวิร์ก
    networkmanager = {
      enable = true;
      dns = "none";  # ปิด DHCP DNS เพื่อใช้ nameservers ด้านบน

      extraConfig = ''
        [main]
        dns=none

        [ipv4]
        ignore-auto-dns=true

        [ipv6]
        ignore-auto-dns=true
      '';
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
