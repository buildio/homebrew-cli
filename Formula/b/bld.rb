class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.0.21.tar.gz"
  sha256 "c36bdb74f0be2b8acf8ea8be9c857813e590a3ac73c43a482d92efeacba59c52"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "openssl@3" => :build
  depends_on "libssh2" => :build
  depends_on "crystal" => :build

  def install
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
