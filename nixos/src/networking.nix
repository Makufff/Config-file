{ ... }:
{
  networking = {
    # ปิด DNS Extension Mechanism ของ resolvconf
    resolvconf.dnsExtensionMechanism = false;

    # ตั้ง DNS ถาวร
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    # ใช้ NetworkManager
    networkmanager = {
      enable = true;
      dns = "none"; # ปิดรับ DNS จาก DHCP

      # เพิ่ม config บังคับ connection ใช้ DNS ที่ตั้งเอง
      connectionConfig = ''
        [ipv4]
        method=auto
        ignore-auto-dns=true
        dns=1.1.1.1;8.8.8.8;

        [ipv6]
        method=auto
        ignore-auto-dns=true
      '';
    };

    # เปิด Firewall + ตั้งพอร์ต
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 53 67 80 443 ];
      allowedUDPPorts = [ 22 53 67 80 443 ];

      allowedTCPPortRanges = [
        { from = 1000; to = 65535; }
      ];

      allowedUDPPortRanges = [
        { from = 1000; to = 65535; }
      ];
    };
  };
}
