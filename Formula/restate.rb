class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d22d7e77332c34c04f536d7afef6ed4ac00c292ea9e804fc7a2b992a701e29f4"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0ecca94283b8f3375fb6bca935a0a88b0172c888945a30aa047f6427111e2bbc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5cad214119eb11dd3032439ea550d4c85dadc751d2ecd1177df2476c31af4fca"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ccccad1701e436b8269494dbc67fc05a1411e4a4a4f8f76d85b1ac029f45c9b5"
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
