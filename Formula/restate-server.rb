class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "69d829eb073a25bde802e7a78fde404db206a432902ef959c16c2648eefe8df1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "2d5d8aa969f372448a6509da9e9b961a1f1b2b8bbcd32218e9c5f9cdd7614098"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "689c6ec65498b549a1b5ddab4fc473bebfa6bbefa7d74ea563c27b4da267d78b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "485d9c2493a0d1c6164cb88dcff9e380b4f00249aa288798bff87fe97e6db753"
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
