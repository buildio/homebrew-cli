class Bld < Formula
  desc "Build.io CLI - Command-Line Interface for Build.io Platform"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.17.tar.gz"
  sha256 "171fddb75edc5f4ce29ab3e4348c11d14f237c7e057b407511889a27da5769a5"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "crystal" => :build
  depends_on "libssh2" => :build
  depends_on "openssl@3" => :build

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
