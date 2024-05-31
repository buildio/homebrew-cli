class Bld < Formula
  desc "Build.io CLI - Command-Line Interface for Build.io Platform"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "dbb138dd368b5e5aa71d9d3ac4a1d2e4660f765c64fb59fc7699d4c6d245acc2"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "libssh2" => :build
  depends_on "crystal"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libssh2"].opt_lib / "pkgconfig"
    ENV.prepend "LIBRARY_PATH", Formula["libssh2"].opt_lib
    ENV.prepend "C_INCLUDE_PATH", Formula["libssh2"].opt_include

    mkdir bin
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/bld"
    bin.install "./bin/bld"
  end

  test do
    assert_match "Error: not logged in",
      shell_output("#{bin}/bld whoami 2>&1", 1)
  end
end
