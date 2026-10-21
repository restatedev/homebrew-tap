class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "e2ea3dce01140981fe4d15a09e53718681574d3a290f5566b1025b4a2696a3eb"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "c6c079291b6171ff34358dd94b9315d5c374fc1e2ca96b62573caf8ac047e6c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7d30d4c73a6978f7b4e4a2c08163fbf4e5689c4534af013bb8fd37e003474857"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "56f12ccc54ee227657d4d8b070622849977444425184ee242a33e3ccc28bf745"
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
      bin.install "restate-server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate-server"
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
