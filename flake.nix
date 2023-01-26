{
  description = "Convert characters.dot to characters.png";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = with pkgs; stdenv.mkDerivation {
          name = "dot2png";

          buildInputs = [
            graphviz
          ];

          src = ./.;

          installPhase = ''
            mkdir $out
            dot -Tpng -Gdpi=300 -o $out/characters.png $src/characters.dot
          '';
        };
      });
    };
}
