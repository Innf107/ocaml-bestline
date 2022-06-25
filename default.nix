{ lib, nix-gitignore, buildDunePackage }:

buildDunePackage rec {
  pname = "bestline";
  version = "0.1.0";
  duneVersion = "3";

  minimalOCamlVersion = "4.14";

  src = nix-gitignore.gitignoreFilterSource lib.cleanSourceFilter [ ] ./.;
  checkInputs = [ ];
  propagatedBuildInputs = [ ];
  passthru.checkInputs = checkInputs;

  meta = { homepage = "https://github.com/Innf107/ocaml-bestline"; };
}
