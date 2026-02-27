{
  description = "TODO: project description";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Language toolchains (uncomment the one you need) ───────────
    #
    # Rust (via fenix):
    # fenix = {
    #   url = "github:nix-community/fenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # Node (via dream2nix or just nixpkgs nodejs):
    #   Node is typically available directly from nixpkgs.
    #
    # Go:
    #   Go is typically available directly from nixpkgs.
    #
    # Python:
    #   Python is typically available directly from nixpkgs.
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          lib,
          system,
          ...
          # If using fenix, add: inputs', and uncomment the rustToolchain let binding below
        }:
        # ── Language toolchain bindings ──────────────────────────────
        # Uncomment and configure for your language:
        #
        # let
        #   # Rust (requires fenix input):
        #   rustToolchain = inputs'.fenix.packages.stable.withComponents [
        #     "cargo" "clippy" "rust-src" "rustc" "rustfmt" "rust-analyzer"
        #   ];
        # in
        {
          # ── treefmt ──────────────────────────────────────────────
          # Enable formatters for your language. Common options:
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;

              # Rust:
              # rustfmt = { enable = true; package = rustToolchain; };
              # taplo.enable = true;  # TOML formatter

              # Node/TS:
              # prettier.enable = true;

              # Python:
              # ruff-format.enable = true;

              # Go:
              # gofmt.enable = true;
            };
          };

          # ── pre-commit hooks ─────────────────────────────────────
          pre-commit = {
            check.enable = true;
            settings.hooks = {
              treefmt.enable = true;

              # ── Security hooks (see rules/10-security-verification.md) ──
              # Uncomment during bootstrap based on project needs.

              # Secret scanning:
              # trufflehog.enable = true;

              # Dependency auditing (language-specific):
              # cargo-audit.enable = true;     # Rust

              # Static analysis:
              # clippy.enable = true;           # Rust
            };
          };

          # ── devShell ─────────────────────────────────────────────
          devShells.default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];

            buildInputs = [
              # ── Common ──
              # pkgs.just           # task runner

              # ── Rust ──
              # rustToolchain
              # pkgs.cargo-watch
              # pkgs.pkg-config
              # pkgs.openssl

              # ── Node/TS ──
              # pkgs.nodejs_22
              # pkgs.pnpm

              # ── Python ──
              # pkgs.python312
              # pkgs.uv

              # ── Go ──
              # pkgs.go
              # pkgs.golangci-lint

              # ── Nix tooling ──
              pkgs.nixd
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
              pkgs.libiconv
            ];

            shellHook = ''
              echo "dev shell ready"
            '';
          };
        };
    };
}
