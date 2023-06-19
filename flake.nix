{
  description = "Smart Energy Monitor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    deploy-rs,
    flake-utils,
    nixos-hardware,
    nixos-generators,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem ["aarch64-linux" "x86_64-linux"] (localSystem: {
      checks = import ./nix/checks.nix inputs localSystem;

      devShells.default = import ./nix/shell.nix inputs localSystem;

      packages = {
        default = self.packages.x86_64-linux.gateway-vm;

        gateway-vm = nixos-generators.nixosGenerate {
          pkgs = import nixpkgs {inherit localSystem;};
          system = "x86_64-linux";
          format = "vm";
          modules = [
            ./software/gateway
          ];
        };

        gateway-raspi = nixos-generators.nixosGenerate {
          pkgs = import nixpkgs {inherit localSystem;};
          system = "aarch64-linux";
          format = "sd-aarch64";
          modules = [
            ./software/gateway
          ];
        };
      };

      nixosConfigurations.gateway = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./software/gateway
        ];
      };

      pkgs = import nixpkgs {
        inherit localSystem;
        config.allowUnfree = true;
        config.allowAliases = true;
        config.allowUnsupportedSystem = true;
      };

      deploy.nodes.gateway = {
        hostname = "sem";
        fastConnection = true;
        profiles = {
          system = {
            sshUser = "sem";
            path =
              deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.gateway;
            user = "root";
          };
        };
      };
    });
}
