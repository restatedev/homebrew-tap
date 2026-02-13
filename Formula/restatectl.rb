class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "ee54c962b2f3e549f07e8bc90976565786e8cd3544435c8bd0a74784d3cd4a4c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "86961d157c342183b429c27af81b5a85b2ab131cd80b681365f022ffdd58adbf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f1e134e284d4794e5c15170841d0cb1fb5e96998a6647f90b022d6bed6707426"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d8bdbdb6ff0908b16b6b0e786dfc9aa2ce35c3d8da7ae8597295f9b2ecf4f41f"
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
