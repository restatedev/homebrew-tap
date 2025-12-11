class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "c2955da7e9569eee8ae53dae49b1d6f19bac66655362c30caa2cf78be16d91e5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "bb7e1d786f5a54bde64ea5888962fc30522cb7c653b4ac36695f49d5c3811345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e4cad86bc5209973a0c4cc9fd21315e741506803119aebae5221c6808687ad89"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cdff7630c4b9669ae858c7fd6694d55b2735e7f1ae6030d69a9e76aad82fe6c4"
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
