class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "7426a3d57a7ded0b94827c4b0b8888278d60acce1544562da64c33cdfaff08ba"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "d3375af1ae2051c5c1252e7cb6b4ac1cd0ab5eff37d9b1e0118142935518ba94"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ef3a4e06900445ad55c69bd01fc9a25a929e038383ed3ad1db007f68954eee7e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5048a9371d9a17698d794adac16d49c76cdbe1e0b742c44445be8480622f46ac"
    end
  end
  license "BUSL-1.1"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "restatectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.mac? && Hardware::CPU.intel?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
