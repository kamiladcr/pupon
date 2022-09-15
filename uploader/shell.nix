{}:
let
  pkgs = import (builtins.fetchTarball
    "https://github.com/nixOS/nixpkgs/archive/22.05.tar.gz"
  ) {};

in
with pkgs; mkShell {
  buildInputs = [
    stack
  ];
}
