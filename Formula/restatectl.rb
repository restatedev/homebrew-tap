class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "6d2d20d197c4bf0ea1a220246488f109c3227ce55761de9348d4b598a9fa6127"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "be80646a0e7dd5e8703cf6b60380db9e34650bc5076cd6117a6057b7c17f3130"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5c31f60f17c8bb9b98f348a44e85f5e25f9dcebf542281345abcf9a67ac3d262"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "32b70f08426e42469b097b321e417c2da616dbf08813cb8870bd267f9c6538da"
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
