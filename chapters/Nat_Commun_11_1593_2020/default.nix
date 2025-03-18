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
  pname = "Nat_Commun_11_1593_2020";
  version = "1.0";
  src = lib.fileset.toSource { root = ./.; fileset = lib.fileset.difference ./. ./Chapter.tex; };
  data = fetchzip {
    url = "https://zenodo.org/records/14931097/files/Nat_Commun_11_1593_2020.zip";
    hash = "sha256-gHoxRPjjXRA7whMLWaY3ojrjRLL9bedlCvM8c7f962w=";
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
