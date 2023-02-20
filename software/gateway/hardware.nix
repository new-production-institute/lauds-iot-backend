{
  lib,
  pkgs,
  config,
  ...
}: {
  hardware.bluetooth.enable = lib.mkDefault true;
  hardware.i2c.enable = lib.mkDefault true;
  hardware.sensor.iio.enable = lib.mkDefault true;

  services.fwupd.enable = lib.mkDefault true;
  services.upower.enable = lib.mkDefault true;
  services.tlp.enable = lib.mkDefault true;

  programs.usbtop.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    dmidecode
    lshw
    pciutils
    usbutils
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
