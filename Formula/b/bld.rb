class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.72.tar.gz"
  sha256 "bb9f252eb023152896309d0bd26cdbe3c80842153f4287e7df922e4e7f8d6660"
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
