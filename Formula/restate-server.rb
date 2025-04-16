class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "05bd1fdbb120e3febb68bb21619ebaceff6a624cff61373b1ce3d689ae5f9819"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "1fcd7d4b42920026e5698b00b198f01dfdb9c5d8e4dd9966be4d95c50909651d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4e9e2619a5e26309b080ddc9d65eec7a8fe5015f1cb80a7ce90f5d46b8676725"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f154e921714bbed4a3255fa864de2db86b142d8f455b2f1a3dbfc557e3d19d6b"
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
