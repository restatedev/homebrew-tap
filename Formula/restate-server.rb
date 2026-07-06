class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "1ac6b28f697ab5a9ca2755eeb5dd54e73ae07ae64c68cfa49963ee88417c3bde"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "d8d7cc3df136a07aab7be85e287975870ede76d828a3dbe956797de017cc48c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d818f5cfd2e0be7b9fe1af28b96b94b6d44daa93c641338d0405594e7664f555"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d702d2db5d47490dce0ef8cded509963d1a4d434ac5d645d61df216d6b5df19b"
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
