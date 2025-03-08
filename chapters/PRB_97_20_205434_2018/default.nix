{ stdenv
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
  src = ./.;
  data = fetchzip {
    url = "https://zenodo.org/records/14894183/files/PRB_97_20_205434_2018.zip?download=1&preview=1&token=eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImE0NmFkZDM1LWUyOTItNGJhZC04OTcxLWQzM2QzMjc0MTA2MCIsImRhdGEiOnt9LCJyYW5kb20iOiJlZWRmMjcyZmZiZjE5ZTdlOTNiYmFjODYyZjFmMmM0ZCJ9.iTp8MLXQNwDqVJPjPOvHDiRMZPI6osKt9o6_1bzTmzWJiWbgxkwMGr2KTWauz_wZOI43oez816MR-EKaXdV0og";
    hash = "sha256-GjOm4GGsNPsE5McIaxZi62pk1xS9fXvpovqghMmfdjU=";
    extension = "zip";
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
