class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.0/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "6c9e8a45880dc37ad33b1e994ed36b85c671fb741a25af082dec83d0112e881b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.0/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "20f262eda0bec32ffdf34d19bb31ac338b4dd8b028e0e4200654634022df99d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.0/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d4bff32fe7caa10433efd75e0e8e50e502b2740dcf689721d7370826ad7e001f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.0/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5ab9bfb1d2a9da5a0327296fcea8c8cb21787441b23321f224064b8cedc6e8f6"
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
