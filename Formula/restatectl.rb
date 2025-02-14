class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "e8d9176cb2eac1157decf81920b2b60ef7d9816ef0ddd5c4bd7d2cc55bf92dce"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "403d9a21cacd3cd43269dafa237f0acec3e3be59a5a1b5fe12a64a7b87839762"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1cf7299d13290e1139cf3e08bb3f6103f7831fc31efc4e00461c9553763ec252"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3d037c71187fd1fa5c74c3213631bdd89fe343577fad589c0ae131ceb69e658d"
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
