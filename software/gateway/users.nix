{
  lib,
  pkgs,
  ...
}: {
  users.mutableUsers = lib.mkDefault true;
  users.users.fabnet = {
    isNormalUser = lib.mkDefault true;
    initialPassword = lib.mkDefault "fabnet";
    extraGroups = lib.mkDefault ["wheel"];
    createHome = lib.mkDefault true;
    shell = lib.mkForce pkgs.zsh;
  };
}
