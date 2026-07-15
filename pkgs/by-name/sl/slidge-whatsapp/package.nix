{
  lib,
  python3Packages,
  fetchFromCodeberg,
  
  gopy,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "slidge-whatsapp";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;
  
  src = fetchFromCodeberg {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "slidge";
    repo = "slidge-whatsapp";
    tag = "v${finalAttrs.version}beta1"; #marked as stable release
    hash = "sha256-jij6lD3Wf+9Q8l5j46O10PPPbpy2+aL84DXA7UaZuUE=";
  };
  
  build-system = with python3Packages; [
    poetry-dynamic-versioning
    poetry-core
    pybindgen
    packaging
    gopy # https://codeberg.org/slidge/slidge-whatsapp/src/commit/36bb8aba40e28124cd4ff9d5e930f45e29ff7c82/build.py#L70
  ];
  
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
})
