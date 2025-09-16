class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "c60eacfbe0d1098a194396706553d46c525737fd8bd160d9463fa67ffde722fd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "0667fe8cb1c94ea3f7928e5e44db8db194ddc9840b1a955f5c3b5bf73fb5f5a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "aca3663366599441c15c3a65a52f8a48c5b7db1f606ec77f225877d3456f7fdd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9fd5679858c67161f08090666a692e91cd7ebabef95d7a53217a4e857b22f60d"
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
