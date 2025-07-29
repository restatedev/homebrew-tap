class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "e6a3a6b65f996f8a909c0abdf2233e390c7d3c00dacbc811374dbf3bc1eaeb1f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "7683bc00c5c726bd4958817483abb910d3493f33689ff061bc0c5d1e0ad39455"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "16b0f68feb8a351a4745f3122329ea677da4ef1116d02b5f23a86f162254f843"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "53a02aa24c2e8f3583c5be12aa95621b225a9c30ac2b195211bc5b695a45207b"
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
