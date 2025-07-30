{
  description = "A Nix Flake with global packages for development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Adjust the branch as needed
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { inherit system; };
    lib = pkgs.lib;
    stdenv = pkgs.stdenv;

    globalPackages = with pkgs; [
      zsh git gnumake pkg-config cmake radicle-node rpm dpkg ninja jq # tools
      clang clang-tools lld  # (Objective) C/++ toolchain
      rustc cargo wasm-pack wasm-bindgen-cli bacon # rust toolchain
      swift swiftpm # swift toolchain
      nodejs # typescript toolchain
    ] ++ lib.optionals stdenv.isLinux [ gcc gnustep-base gnustep-gui gnustep-make gnustep-libobjc ]
      ++ lib.optionals stdenv.isDarwin [ libcxx apple-sdk ];
  in {
    packages = {
      default = pkgs.mkShell {
        buildInputs = globalPackages;
      };
    };

    # Exporting the globalPackages variable
    globalPackages = globalPackages;
  };
}
