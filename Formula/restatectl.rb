class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "4d1274384f98e0bbb7cbce99e93a492e6cd9f375f94079d18bf651f891bd4e5d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "f2f1e2a2d8e686b4884e8a954b558b58d1cf50030fea9fed525b225ba67b576d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "63a1d89334fa2a821b2f143c00da5de9023c96439db2a3824e6a91c8aa1c8883"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f6a380d6f111772cc020abc299ab8ca8c1039e8c3bcf08eeaf97092ecdbd9741"
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
