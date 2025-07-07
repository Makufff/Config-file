{ ... }:

{
  networking = {
    # ใช้ NetworkManager
    networkmanager.enable = true;

    # ไม่ตั้ง nameservers เอง ใช้ DNS จาก DHCP
    # networking.nameservers = []; # ไม่ต้องใส่

    # Firewall เปิดพอร์ตที่จำเป็น
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 53 67 80 443 ];
    firewall.allowedUDPPorts = [ 22 53 67 80 443 ];
    firewall.allowedTCPPortRanges = [{ from = 1000; to = 65535; }];
    firewall.allowedUDPPortRanges = [{ from = 1000; to = 65535; }];

    # ตั้ง hostname ถ้าต้องการ
    hostName = "nixos";
  };
}
