{
  description = "Dev environment for Discord Bot and Firefox Extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          fastapi
          uvicorn
          httpx
          python-dotenv
          asyncpg
          psycopg2
          supabase-py
          discord-py
        ]);

        nodePackages = pkgs.nodejs_24;

      in {
        devShell = pkgs.mkShell {
          name = "discord-bot-env";

          packages = with pkgs; [
            nodePackages
            pythonEnv
            docker
            git
            openssl
            pkg-config
            # Optional:
            # firefox  # For testing extension manually in dev
          ];

          shellHook = ''
            echo "Welcome to the dev shell!"
            echo "Node version: $(node --version)"
            echo "Python version: $(python --version)"
            echo "Docker version: $(docker --version || echo 'Docker not available')"
          '';
        };
      }
    );
}
