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

    # Firefox Extensions
    firefox-addons = { 
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    # Neovim manager
    nixvim = {
      # url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      url = "github:nix-community/nixvim/nixos-24.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    settings = import ./utils/settings.nix { inherit pkgs; };
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${settings.system};
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
        # Calls the configuration.nix file to built the system
        "${settings.hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit settings;};
          modules = [
            ./system/configuration.nix
          ];
        };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
        "${settings.user}@${settings.hostname}" = home-manager.lib.homeManagerConfiguration {

          pkgs = pkgs; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs settings;};
          modules = [ ./home ];
        };
    };

  };
}
