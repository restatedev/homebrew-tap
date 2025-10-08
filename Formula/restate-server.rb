class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "1d4ccf78c48c8ad6e62001018e500b9e66a14ed16368d40380a91dd39720c4a1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "da88b86beac3a58272eb5dfff66a5dc2618cdb0a8be4bd9651d11e04c5dc68bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4462e6ac1b4bcaa0e1c66efe5da901f45cff292f10ec2cbab2204aeba136a661"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "47dddbc2cd5945dbfb7c65c96a5a52d6f594494c685df9a684b8a319f929ea38"
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
