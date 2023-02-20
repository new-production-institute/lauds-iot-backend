{lib, ...}: {
  boot.kernel.sysctl = lib.mkDefault {"vm.swappiness" = 10;};
  boot.tmpOnTmpfs = lib.mkDefault true;
  boot.cleanTmpDir = lib.mkDefault true;
}
