{self, ...}: system:
with self.pkgs.${system};
  mkShell {
    name = "Smart Energy Monitor";
    nativeBuildInputs =
      [
        # Development
        editorconfig-checker
        esptool
        micropython
        nodePackages.node-red
        openscad
        pre-commit
        python310Full
        python310Packages.mkdocs
        python310Packages.mkdocs-material
        python310Packages.mkdocs-material-extensions
        yaml-language-server
      ]
      ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
        vscodium-fhs
        freecad
      ]
      ++ [
        # Linter
        git
        yamllint

        # Nix
        deploy-rs
        alejandra
        nixUnstable
        rnix-lsp

        # Service
        mosquitto

        # Misc
        reuse
        zstd
        wget
        raspberrypi-eeprom
      ];
    shellHook = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
    allowUnsupportedSystem = true;
  }
