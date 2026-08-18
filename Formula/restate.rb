class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a9eeb3e27fe533db0815e6326959d3fdc568fbd8a31ffb00083bf7f4c438a75d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "612ff4a1d42824884cceec5a78428a4b18d95d53fe19b366385150dfd7ae02f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1aa91601a41b6b0c41aef61afc72d10e23a91e91ed31ae1b20bf6b843ba2f4a4"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cfe2da7c9c10e75c694d370a4605db90492c89ffca2d3798d0144de3ef2876ec"
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
