class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6023854d8211cbaee4201f20ff51d90165a5617eeff9ffe95eba94f661fd5f20"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3ca3772d6d8e41ac49b8e41611322dd7af3ef371e0e531258e7b86e236afba74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "82cab70823ac7c50bb33b0c393cd75cb46b87f018091a83eb4b24c5a332072f3"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "10cc901ae3c85e58ec7c4e8560686f900c8ad65b2b2f0d13f47cea4b9ef94bbd"
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
