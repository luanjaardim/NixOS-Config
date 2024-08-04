{
  description = "My personal Flakes Nixos configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    system = "x86_64-linux";
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
        # Xorg Nixos configuration
        x-nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [
            # > Our main nixos configuration file <
            ./system/configuration.nix
          ];
        };
        # Wayland Nixos configuration
        w-nixos = {
          # TODO: make nixos config for wayland
        };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
        "lan@x-nixos" = home-manager.lib.homeManagerConfiguration {

          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [ ./home ];
        };
    };

  };
}
