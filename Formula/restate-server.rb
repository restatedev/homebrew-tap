class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "3d5fec2c7c548d308475994b9026650ffefbf9f98235d3a7025837f0c7f27bab"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "2f48773660bad00d4d042222a66de8f5c2fadab874a8e9d680b5a4a31bde4966"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "55d35b3bb9ba4c714a6daab426d9f559c13a581465bc1bfa3274017f012ed273"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "31211f8eb0048618712d0cf5b884bd58224bdb6aea876010a8934bd0fa0667de"
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
