class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ffe25c0522fec2e51a5f82f980de2f9ee9ba0b97e508d0871024553f8e0d9659"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "155582d89a1ba4297705b392444d2437eb5a7f9c677f476b111682ed769e132a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3a2aa33cdad18de6aef0acc69fd0f638dba8e454d799c31207f5043c91607870"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "daaf056f1c72c7e6d3f7e9b932ac172aaf806f7d72bf16aab381945afd308452"
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
    bin.install "restate" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
