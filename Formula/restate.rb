class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "caaf37e792a4cd7145072662988b4975fd994bceda97f327e48b97012e8e6aa0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e7ec1cf1331f4f1e66057e2d1c37cdf3a3be0acf8d54702d8604ae1e926d6ec3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6a22ed91caf131c290de5868cf0fcf2ae60533bacad1f207aff3054fbd63a86b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b03aff786082f105ff85cd4e6d252f2ef48a61f8603cd6e8c597ce9baaa68c0c"
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
