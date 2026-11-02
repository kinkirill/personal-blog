{
  description = "Personal Blog";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          hugo
        ];

        shellHook = ''
          export LD_LIBRARY_PATH="${with pkgs; lib.makeLibraryPath [ ]}"
          echo ""
          echo "🇭 🇺 🇬 🇴 :  $(hugo version)"
          echo ""
        '';
      };
    };
}
