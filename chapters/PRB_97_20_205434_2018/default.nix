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
  pname = "PRB_97_20_205434_2018";
  version = "1.0";
  src = lib.fileset.toSource { root = ./.; fileset = lib.fileset.difference ./. ./Chapter.tex; };
  data = fetchzip {
    url = "https://zenodo.org/records/14894183/files/PRB_97_20_205434_2018.zip";
    hash = "sha256-GjOm4GGsNPsE5McIaxZi62pk1xS9fXvpovqghMmfdjU=";
  };
  nativeBuildInputs = [ (latexPackages texlive) (pythonPackages python3) ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    ln --symbolic -v ${finalAttrs.data} data
    export MPLCONFIGDIR=$(mktemp -d)
  '';
  buildPhase = "jupyter nbconvert --to script Figures.ipynb && python3 Figures.py";
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
