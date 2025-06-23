class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "eadbd6bfab4b1019d7f3405a514a8fbdadeeb1ec76be40fdce3548fab4e2d7d5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e9e7f12d86d0883fa4036cfd5aff17d812a06ecc92c6ab63f722765bc16b7110"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7667d8a65f7f7f1d86bc8661c37cbdfdd01c4c5705b98d53193e523a2a2229f8"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2961d020e0bacfe36a11a60493ceca10833660e93c201dd9fae40d4fb7bdc8e0"
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
