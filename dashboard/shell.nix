{}:
let
  pkgs = import (builtins.fetchTarball
    "https://github.com/nixOS/nixpkgs/archive/nixos-unstable.tar.gz"
  ) {};

  pythonEnv = pkgs.python3.withPackages (pypi: with pypi; [
    dash
    pandas
    psycopg2
    sqlalchemy
    setuptools
  ]);

in
with pkgs; mkShell {
  buildInputs = [
    pythonEnv
  ];
}
