class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "7dd852e4775a0a961b004ebfcd77570f31b5827742923bf3005fe522745d1710"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "24206c0db704b73d0656d3844fe58c160b6700efdd21795b58c486858a96b791"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a887fd5018562934ae3a05e8a2695823f90f2455e180123734b9ddde432c3310"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d33244449651ee68f01c71271b04bb3c13e8a8305627247ef41a7f12c6c0a0f5"
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
