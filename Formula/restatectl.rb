class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "691c91679c695bfaa36c7c30fab898f5ebb835d4bbabb1fe5ab966349e782a1b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "7906fc180e733b587768680598f7b46f957c7d216d7c0d19a8d89613173b1dad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "910a627c56f37efadb1870c8610f138cd7e74406925ad1a23b3590663aed7d9c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4655a7b86ebaccfba0a96b52c75380c82d8c1542e59b0bb4b2f0f4238aa0adba"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restatectl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
