#! /usr/bin/zsh

xcode-select --install
brew install rustup deno git cmake
rustup default stable
rustup target install wasm32-unknown-unknown
cargo install bacon wasm-pack wasm-bindgen-cli