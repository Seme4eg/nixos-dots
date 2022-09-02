{ lib, rustPlatform, scdoc, rustup, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
    # rev = "d25721020d494701236c99869f4abb85346caba3";
    # rev = "refs/tags/v${version}"; # source: https://gist.github.com/boxofrox/d8a3080fbb03f84b7d7a31e102b35f09#file-b-default-nix
    sha256 = "IquKXZXT0hUoEwDf7cC6J3IgzzeptPAKgJFznzlP0vU=";
  };

  cargoSha256 = "ac7bLpxe+GgD0CLlMyP8A8xD4TqmYtay2vlkFV5jFQ0=";

  meta = {
    homepage = "https://github.com/waycrate/swhkd";
    description = "Simple Wayland HotKey Daemon";
    # license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
