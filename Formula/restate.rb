class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "88e00ddc3baf503d95c59567f6f2fbf29c9f535f234c83db67194e542e3effd3"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "254aed9bcb2f5e84231b7a7667866392d9440e6e84a88fec714e1a1a352b1e57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9ec7249c92f0f1aa366eda805d0f9de42d0dd416cf87f87a14b9c0fb954bac4b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f961e947f6e321fcdbc604f7320292bab26a3f92f9cec01f500b2670780bc5f0"
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
    bin.install "restate" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
