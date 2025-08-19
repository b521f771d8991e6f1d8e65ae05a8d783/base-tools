{
  description = "A Nix Flake with global packages for development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay
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
            overlays = [ rust-overlay.overlays.default ];
          };

          lib = pkgs.lib;

           rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" ];
            targets = [
              "x86_64-apple-darwin" "aarch64-apple-darwin"
              "x86_64-unknown-linux-musl" "aarch64-unknown-linux-musl" "x86_64-unknown-linux-gnu" "aarch64-unknown-linux-gnu"
              "wasm32-unknown-unknown"
            ];
          };

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
              lld # (Objective) C/++ toolchain
              rustToolchain
              wasm-pack
              wasm-bindgen-cli
              bacon
              swift
              swiftpm
              nodejs
            ]
            ++ lib.optionals stdenv.isLinux [
              gnustep-base
              gnustep-gui
              gnustep-make
              gnustep-libobjc
              dpkg
              pkg-config
              clang
              clang-tools
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
