{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    nuix.url = "github:GuilloteauQ/nix-overlay-guix";
  };

  outputs = { self, nixpkgs, nuix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      packages.${system} = {
        start = pkgs.writeShellApplication {
          name = "start";
          runtimeInputs = [ nuix.packages.${system}.guix];
          text = ''
            guix-daemon
          '';
        };
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nuix.packages.${system}.guix
            proot
          ];
        };
      };

    };
}
