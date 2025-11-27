class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f4ea53587dcf41687685cc03d7ca8b0b66a2e522ed544bad06063ac1df84d8e7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "437715c8f0580f988729c41fa687c1d52d9a90a7d48649214c454a2b609891ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0f3171e71c92792371599b5992f1e466c67f232172b30dd03e370a83b7571b3e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6f24c3b9275b0e9e7c6f4bdaab414e2e82aacd4a60c6118123c4259da23c5f89"
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
