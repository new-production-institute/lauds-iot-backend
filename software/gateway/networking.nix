{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.enable = lib.mkForce true;
  networking.wireless.enable = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkDefault true;

  services.avahi.enable = lib.mkDefault true;
  services.avahi.nssmdns = lib.mkDefault true;
  services.avahi.publish.enable = lib.mkDefault true;
  services.avahi.publish.addresses = lib.mkDefault true;
  services.avahi.publish.domain = lib.mkDefault true;
  services.avahi.publish.userServices = lib.mkDefault true;
  services.avahi.publish.workstation = lib.mkDefault true;
  services.avahi.extraServiceFiles.ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
}
