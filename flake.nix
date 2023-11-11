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

      nixosConfigurations = let
        imageConfig = isContainer:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ({ pkgs, ... }:
                {
                  boot.isContainer = isContainer;
                  nixpkgs.overlays = [ nuix.overlays.default ];
                  imports = [ nuix.nixosModules.guix ];
                  services.guix.enable = true;
                  environment.systemPackages = with pkgs; [
                  vim git tmux];
                  users.extraUsers.root.password = "root";
                })
            ];
          };
      in {
        numpex = imageConfig false;
        container = imageConfig true;
      };

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
        vm = pkgs.mkShell {
          packages = with pkgs; [
            qemu
          ];
        };
      };

    };
}
