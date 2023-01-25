{self, ...}: system:
with self.pkgs.${system};
  mkShell {
    name = "iot-platform";
    nativeBuildInputs =
      [
        # Development
        editorconfig-checker
        pre-commit
        python310Full
        yaml-language-server
        nodePackages.node-red
        openscad
        micropython
        esptool
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
        alejandra
        nix
        nix-linter
        rnix-lsp

        # Service
        mosquitto

        # Misc
        reuse
      ];
    shellHook = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
  }
