class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.81.tar.gz"
  sha256 "621b5601d4baa38e338771742f13a3de0dd53766499a4181ba7b908387b61836"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "crystal" => :build
  depends_on "libssh2" => :build
  depends_on "openssl@3" => :build
  depends_on "pcre" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["CRYSTAL_LIBRARY_PATH"] = [
      Formula["pcre"].opt_lib,
      Formula["openssl@3"].opt_lib,
      Formula["libssh2"].opt_lib,
    ].join(":")
    mkdir bin
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/bld"
    bin.install "./bin/bld"
    ohai "----> Login to Build.io to get started."
    ohai "      bld login"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bld --version").chomp
  end
end
