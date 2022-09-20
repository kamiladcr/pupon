{}:
let
  pkgs = import (builtins.fetchTarball
    "https://github.com/nixOS/nixpkgs/archive/nixos-unstable.tar.gz"
  ) {};

  pythonEnv = pkgs.python3.withPackages (pypi: with pypi; [
    # Our application will work based on dash (simple web applicaton with python)
    dash

    # This is a postgres connector for python and
    # and alchemy-thingy for creating connections
    psycopg2
    sqlalchemy

    # Pandas!
    pandas

    # Shell requires pkg_config for some reason,
    # so we need setuptools that has it.
    setuptools
  ]);

in
with pkgs; mkShell {
  buildInputs = [
    pythonEnv
  ];
}
