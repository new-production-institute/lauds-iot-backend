{
  pkgs,
  lib,
  ...
}: {
  security.protectKernelImage = lib.mkDefault true;
  security.forcePageTableIsolation = lib.mkDefault true;

  security.polkit.enable = lib.mkDefault true;
  security.apparmor.enable = lib.mkDefault true;

  security.sudo.enable = lib.mkDefault true;
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
}
