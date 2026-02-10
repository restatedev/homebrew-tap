class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "86f50943970c10a060051ce7523d344da80e97267af6a9a7a4003a00110a1c7b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "d9ebcc563c8ec48e4b26a516ac0b8df8c475d2ff620bd965d6ec2dc92a4b58e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "690bc6ca916ada0bb275945303b9341fdab0ca1d32b66bceaa394b3d2cbaba82"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "42cf3be3f7ca845d2880de3af4f3ba8b74d94d1519688270f0f114ff8e88c517"
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
