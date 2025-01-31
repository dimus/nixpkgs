{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "digimend";
  version = "unstable-2019-06-18";

  src = fetchFromGitHub {
    owner = "digimend";
    repo = "digimend-kernel-drivers";
    rev = "8b228a755e44106c11f9baaadb30ce668eede5d4";
    sha256 = "1l54j85540386a8aypqka7p5hy1b63cwmpsscv9rmmf10f78v8mm";
  };

  postPatch = ''
    sed 's/udevadm /true /' -i Makefile
    sed 's/depmod /true /' -i Makefile
  '';

  patches = [
    # Fix build on Linux kernel >= 5.4
    # https://github.com/DIGImend/digimend-kernel-drivers/pull/331
    (fetchpatch {
      url = "https://github.com/DIGImend/digimend-kernel-drivers/commit/fb8a2eb6a9198bb35aaccb81e22dd5ebe36124d1.patch";
      sha256 = "1j7l5hsk59gccydpf7n6xx1ki4rm6aka7k879a7ah5jn8p1ylgw9";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postInstall = ''
    # Remove module reload hack.
    # The hid-rebind unloads and then reloads the hid-* module to ensure that
    # the extra/ module is loaded.
    rm -r $out/lib/udev
  '';

  makeFlags = kernel.makeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=${placeholder "out"}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "DIGImend graphics tablet drivers for the Linux kernel";
    homepage = "https://digimend.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
