class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "34b3bbb1982a80296f1aaff5f604b7cffe5c8fde12595e722db2d74524bda14a"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "72c02b9d5e4a8581f1e3c6f5b1829cbbc3c7a2632f203146b76bd63cfd4ac1f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0bed5d04d0da3f158828c675cc4c5b07a303d3c501859e7aa4e70b6a165e20ee"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f867f050f9689c6b3909ba96b450e854c925fe27b77b9c90e16da222d03091aa"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
