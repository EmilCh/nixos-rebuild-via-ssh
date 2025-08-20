{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";

  outputs =
    {
      nixpkgs,
      ...
    }:
    {
      # nixos-rebuild --flake .#generic switch --target-host <hostname>
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };

    };
}
