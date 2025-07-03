{ pkgs, lib, config, ... }:

{
  # Enable all firmware, microcode, and Intel GPU tools
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.intel-gpu-tools.enable = true;

  # Bluetooth config
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Power management: enable with powersave governor
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # Graphics config with extra VAAPI and Vulkan packages
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-vaapi-driver
      intel-media-driver   # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (commented out)
      intel-media-sdk      # Intel Quick Sync Video
      vpl-gpu-rt          # Intel Video Processing Library (GPU runtime)
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
      mesa
      libGL
      libdrm
      mangohud             # GPU performance overlay
      egl-wayland
    ];
  };

  # NVIDIA configuration for hybrid Intel+NVIDIA (Optimus) laptop
  hardware.nvidia = {
    open = true;                     # use open kernel modules for nvidia
    modesetting.enable = true;       # enable nvidia modesetting DRM
    nvidiaPersistenced = true;       # enable persistence daemon (optional)

    powerManagement = {
      enable = true;                 # enable NVIDIA power management
      finegrained = true;
    };

    prime = {
      offload = {
        enable = true;              # enable prime offloading
        enableOffloadCmd = true;    # enable prime-run command for offload
      };
      intelBusId = "PCI:0:2:0";     # PCI bus ID for Intel GPU (from your lspci)
      nvidiaBusId = "PCI:1:0:0";    # PCI bus ID for NVIDIA GPU (from your lspci)
    };

    # Choose NVIDIA driver package, using stable driver from unstable kernel
    package = (pkgs.unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.stable;
  };

  # Tablet driver support if applicable
  hardware.opentabletdriver.enable = true;
}

