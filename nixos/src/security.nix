{
	pkgs,
	...
} : {
  security.polkit = {
    enable = false;
  };
  security.rtkit.enable = true;
  security.pam.services.hyprlock = {
    enable = true;
  };
  se3curity.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "8192000";
    }
    {
      domain = "*";
      type = "-";
      item = "rtprio";
      value = "95";
    }
  ];

}

