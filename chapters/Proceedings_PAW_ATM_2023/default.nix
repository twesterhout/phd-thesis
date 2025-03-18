{ lib
, stdenv
, fetchzip
, python3
, pythonImports
, pythonPackages
, texlive
, latexPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Proceedings_PAW_ATM_2023";
  version = "1.0";
  src = lib.fileset.toSource { root = ./.; fileset = lib.fileset.difference ./. ./Chapter.tex; };
  data = fetchzip {
    url = "https://zenodo.org/records/8329984/files/twesterhout/paw-atm-2023-paw-atm-2023.zip";
    hash = "sha256-S6BWt82UCG0zxXOgPCZVB5RDKFxnwZYK30NfDSroNAQ=";
  };
  nativeBuildInputs = [ (latexPackages texlive) (pythonPackages python3) ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    cp --no-preserve=mode -r ${finalAttrs.data} data
    export MPLCONFIGDIR=$(mktemp -d)
  '';
  buildPhase = ''
    set -e
    pushd data && python3 crawl.py && python3 analyze.py && python3 spinpack.py && popd
    jupyter nbconvert --to script Figures.ipynb && python3 Figures.py
  '';
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
