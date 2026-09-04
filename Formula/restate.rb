class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "558d99a062c57862c9af2a390e2db210a199fd8366a3e0401fcda66a21dc458c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "900367e05bc06ed5cc721c063efa76e743164b11467221bb83b9b486ccbd8bf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2aa31e218eb2a00726618dcf665927b90748abda808bf4ea9f9adddc7168800b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ab05bc63d16b646a2dc27b538a790d9b4494456f210c79258e1c6dda74000846"
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
