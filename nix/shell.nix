{self, ...}: system:
with self.pkgs.${system};
  mkShell {
    name = "Smart Energy Monitor";
    nativeBuildInputs =
      [
        # Development
        editorconfig-checker
        pre-commit
        yaml-language-server
      ]
      ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
        vscodium-fhs
        vscode-extensions.marp-team.marp-vscode
      ]
      ++ [
        # Linter
        git
        yamllint

        # Nix
        alejandra
        nixUnstable
        nil

        # Service
        mosquitto

        # Misc
        reuse
      ];
    shellHook = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
    allowUnsupportedSystem = true;
  }
