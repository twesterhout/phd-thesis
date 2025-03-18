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
  pname = "Commun_Phys_6_275_2023";
  version = "1.1";
  src = lib.fileset.toSource { root = ./.; fileset = lib.fileset.difference ./. ./Chapter.tex; };
  data = fetchzip {
    url = "https://zenodo.org/records/14973515/files/experiments.zip";
    hash = "sha256-ql5ItRTLE0H+dvBvmKvDhpoHWNF/PKhX0Lcq/9rKV+c=";
  };
  nativeBuildInputs = [ (latexPackages texlive) (pythonPackages python3) ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    mkdir -p data && ln --symbolic -v ${finalAttrs.data} data/experiments
    export MPLCONFIGDIR=$(mktemp -d)
  '';
  buildPhase = "jupyter nbconvert --to script Figures.ipynb && python3 Figures.py";
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
