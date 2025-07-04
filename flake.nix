{
  description = "Dev environment for Discord Bot and Firefox Extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodePackages = pkgs.nodejs_24;
        python = pkgs.python3;
        virtualenv = pkgs.python3Packages.virtualenv;
      in
      {
        devShell = pkgs.mkShell {
          name = "discord-bot-env";

          packages = with pkgs; [
            python
            virtualenv
            nodePackages
            yarn
            docker
            git
            openssl
            pkg-config
            python.pkgs.venvShellHook
          ];

          shellHook = ''
            if [ ! -d .venv ]; then
              echo "Creating Python virtual environment in .venv with virtualenv"
              virtualenv .venv
            fi

            source .venv/bin/activate

            if ! pip show discord.py supabase >/dev/null 2>&1; then
              echo "Installing Python dependencies from requirements.txt"
              pip install --upgrade pip
              pip install -r requirements.txt
            fi

            echo "Welcome to the dev shell!"
            echo "Node version: $(node --version)"
            echo "Yarn version: $(yarn --version)"
            echo "Docker version: $(docker --version)"
            echo "Python version: $(python --version)"
          '';
        };
      }
    );
}
