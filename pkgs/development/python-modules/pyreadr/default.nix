{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  bzip2,
  iconv,
  zlib,
  xz,
  pkg-config,
  pandas,
  pytestCheckHook,
  xarray,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyreadr";
  version = "0.5.6";
  pyproject = true;
  __structuredAttrs = true;
  
  src = fetchFromGitHub {
    owner = "ofajardo";
    repo = "pyreadr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGKDEW64LOZUZ0g50COiVw5tJssbIGX5dxYBPjW5J+M=";
  };
  
  nativeBuildInputs = [ pkg-config ];
  
  buildInputs = [ bzip2 iconv zlib xz ];
  
  preBuild = ''
    pushd pyreadr/libs
    rm -r bzip2 iconv lzma zlib
    popd
    
    export CFLAGS="$(pkg-config --cflags bzip2 iconv zlib liblzma)"
    export LDFLAGS="$(pkg-config --libs bzip2 iconv zlib liblzma)"
  '';
  
  build-system = [ setuptools cython ];
  
  
  dependencies = [ pandas ];
  
  nativeCheckInputs = [ pytestCheckHook xarray ];
})
