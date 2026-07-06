class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "f2a39280e48d03f75bc7d3a0da84d2e78516c6072ae0c4eb94f949f8f19037da"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "664dec8387a4a10ffed6d18065a5b517bd9bf4f1463dde92baac213cf959d2c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c46fff717a41cda0465d683705af6c40bc71c0dd766c17ec6f1145b2c0409158"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "acd748fa5488c0939b4a999acc708c85b79b91b21a57bd5c06377d9328a87e4c"
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
