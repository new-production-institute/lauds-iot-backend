{
  pkgs,
  lib,
  ...
}: {
  nix.package = pkgs.nixUnstable;
  nix.gc.automatic = lib.mkForce true;
  nix.optimise.automatic = lib.mkDefault true;
  nix.settings.require-sigs = lib.mkForce true;
  nix.settings.auto-optimise-store = lib.mkDefault true;
  nix.settings.allowed-users = lib.mkDefault ["@wheel"];
  nix.settings.trusted-users = lib.mkDefault ["root" "@wheel"];
  nix.settings.substituters = lib.mkDefault [
    "https://arm.cachix.org/"
    "https://nix-community.cachix.org"
    "https://nix-config.cachix.org"
  ];
  nix.settings.trusted-public-keys = lib.mkDefault [
    "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
  '';
}
