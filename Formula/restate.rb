class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "64b1df688e6de0fe60fb4d165c042bde584b9f0708942b3380dc7011054dcc81"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "10c7142162c9bd436bd4ab851c7091d98149f03f1d3bc78b0d14ac5875cf1d5a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "52eb0d7d836465634921bb019f81886e8fc65159eed6c9ca51c66797614bb8a9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4e53f6e2dd08d12498d002ed9b1019ac93a0e9a46628059d4bd328c18c9a004d"
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
