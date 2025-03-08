{ stdenv
, fetchFromZenodo
, fetchFromGitHub
, julia-bin
, python3
, pythonImports
, pythonPackages
, texlive
, latexPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "2D_Materials_9_1_014004_2021";
  version = "1.0";
  src = ./.;
  data = fetchFromZenodo {
    record = "14993549";
    file = "main.zip";
    token = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjBhOGJiYmFiLTQ3YWYtNDhlNi1iYzlmLWUyNTBlNTZmYjEzOCIsImRhdGEiOnt9LCJyYW5kb20iOiI1NDFlNWM0YmJiMzUzNWVhZTFmYWRmNjJjNWQ2MjU4YiJ9.5hxOd5jGQcHTUqZJdlXWkbYV8xqxSbQBvnldosqG_toCetZlz7VUFZgoWm490EYRFru9VgvNlHh7G0A9y8owuw";
    hash = "sha256-Oq9KdfU4pJpskf+A0mTDbwzEjeZBuTFFwzDOBf97kyc=";
  };
  graphene-plasmons = fetchFromGitHub {
    owner = "twesterhout";
    repo = "graphene-plasmons";
    rev = "e7a8544dcc035a36109088c9bf701d3b3ce94a3a";
    hash = "sha256-dcCA5d9BPaeufrW0CdzBI3jRCGM9uWBg80b2RmijbO8=";
  };
  nativeBuildInputs = [
    (latexPackages texlive)
    (pythonPackages python3)
    (julia-bin.withPackages [ "LinearAlgebra" "FFTW" "HDF5" "LsqFit" ])
  ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    cp --no-preserve=mode -r ${finalAttrs.data} data
    ln --symbolic -v ${finalAttrs.graphene-plasmons}/src src
    export MPLCONFIGDIR=$(mktemp -d)
    export JULIA_DEPOT_PATH=$(mktemp -d)
  '';
  buildPhase = ''
    set -e
    julia -e 'include("graphene.jl"); Figure_1(); Figure_3()'
    jupyter nbconvert --to script Figures.ipynb && python3 Figures.py
  '';
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
