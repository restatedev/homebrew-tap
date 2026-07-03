class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "4920b029a9d96dfab961e6a4c15eff0c2dd07795c2c501169804ac6577bcdf1f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "a11cd3fd69c053e13c04a67f12dc2917c2af014dc90c858d37e982dd2f281400"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "179993a11b556e695ee701a871bae1b92023778e5cdf7211e36c96b8bb68efec"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "102e7df2f037edcc2f518af62f39ce7f6fa1f35a2b44b9d64b75d56195347f7d"
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
