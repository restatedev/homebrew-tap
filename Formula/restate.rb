class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "941ce0261903d6fc4d5e33c35aef0dd3ac3ef7479c4cc1b01e67441b0cf65cc0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8223dc7232a566d3cfd80e10c50f23eeecec21c8ed7dd2e5d35bd7a165f2d255"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "335736bb0ac6953aa7d546b17cfd6f664a29d2e168bb871123367ed248fafcae"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "dc4c4eb30e252da056f9dc7df1f58b8253120c251a1242a1f36a694ccab78e0e"
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
