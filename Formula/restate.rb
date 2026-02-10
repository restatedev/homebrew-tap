class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8c172017e92bb632ad45c60db5175c24227e4103659041a33c5bae3bc7f053f7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "32fca8f837ade9a0adabb15b920b1e7655b311b760203aa4ec4dab8834d131d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7752358525330d8f1503fe152a7cb8abed21dbad484a96f58887a968e80056d6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f68e1d109d4836c5106863c2c2b9d94a8a654aff5c9fbc5646bbd41b90ed1e34"
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
