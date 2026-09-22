class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "4ea980ce3b50edb7418f0bc469777c56c800cd442fe2cc4efb52cc8f6a88c354"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "174de83b4ebe9382db2f795d8ad1b4d2674373ffd368722d9cd1be491cfae991"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "578bf9393e33b8f62d1904fafa2fbf72f4a0343d9c04e8d1c55ce15f1d99ee99"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d2bc44e3cd3128f8a847378f61bee3da9851ecbfb2877ad2b850367817d88014"
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
