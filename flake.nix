{
  description = "A Nix Flake with global packages for development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem
      [
        flake-utils.lib.system.x86_64-linux
        flake-utils.lib.system.aarch64-linux
        flake-utils.lib.system.x86_64-darwin
        flake-utils.lib.system.aarch64-darwin
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = false;
          };
          lib = pkgs.lib;

          stdenv = pkgs.stdenv;

          global-packages =
            with pkgs;
            [
              zsh
              git
              gnumake
              pkg-config
              cmake
              radicle-node
              rpm
              ninja
              jq # tools
              clang
              clang-tools
              lld # (Objective) C/++ toolchain
              rustc
              cargo
              wasm-pack
              wasm-bindgen-cli
              bacon # rust toolchain
              swift
              swiftpm # swift toolchain
              nodejs # typescript toolchain
            ]
            ++ lib.optionals stdenv.isLinux [
              gcc
              gnustep-base
              gnustep-gui
              gnustep-make
              gnustep-libobjc
              dpkg
              pkg-config
            ]
            ++ lib.optionals stdenv.isDarwin [
              libcxx
              apple-sdk
            ];
        in
        {
          devShells = {
            default = pkgs.mkShell.override { } {
              packages = with pkgs; global-packages;
            };
          };

          global-packages = global-packages;
          formatter = pkgs.nixfmt-tree;
        }
      );
}
