class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.92.tar.gz"
  sha256 "452e4572417c347524b0db4f377bb96ffc816518eb3f886aa7ad0a96e2835c2b"
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
