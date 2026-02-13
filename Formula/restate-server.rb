class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "126b4b03cf37cb5998c69ca94386ad321806124eb9b764b3b8a336303c30ef61"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "44c9c93ecbe7c0fb11f1e550d99c49644d5f9ac92c3ef5cc979661eb75372ed5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c35d548b3ebec13a3183c6acbbddc1c3656a1f26423d7d13af141773a09c6cf1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0d022e8beefe4e61dda735450848395ac60e581add37ead023d8f813d3712be1"
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
