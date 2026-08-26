class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b7ca8741b75991b29a12727339ec031cf1c979ba8f41ad58f514ecb7ecdb1c3e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6c6c667ef1a0e9c94288a748e8a6f5c1805d0a6221ec34618a15db82356bd8db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "70b117981e9cc1d34bd588134c8c425ff7ade1003e2eeb4983d58a07962aab21"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3f97a3309f4e005590fbcbef1e3314a27a783f83d14a32e084e5c475e43c898f"
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
      bin.install "restate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate"
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
