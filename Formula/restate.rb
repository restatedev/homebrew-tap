class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a0a4333865d9e0f8c002cc1563d747958aca4ff7bf311e9edf5d194aef065c24"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "34b65f8285fe134aabb0e2dc6b9b851f7403667d935d0e3450f0f50429725911"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7cad362acf6d6a4552bc65945c19ede8a0b07467e28c872f03294edb73f65627"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "281542b9335217a8fb38589c898f2242a72c5ee8e8ca2027170f6caa1f6b360d"
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
