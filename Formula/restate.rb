class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "32b9dc237a46f3d7bda8d03ef40da633c446e8555cf2f0bea9a7d20f3cffecb6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5a49f65b9bbaaaae9d8eb80a81099dd3ebdc4172afdbd7388b4416b121f1021e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "730afbf3bbdd4cf0f69b956fc88b04ab166c9a9460f26a3980f0941e388ed0a8"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "29f4d94aade8fc0546dd9991553e01af0f3ef5c4e20b07a226dc695654f42629"
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
