class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3ebbae631d60f08eb0ffc4e1becdaf1b9c08624b86f609a0789ba9fbaecc6da5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c44899c7c5106afc0bcbdf77341e6f62d68e93ff7297cc279e21f490125ff62a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1731e8404ec5e52e84ca64323c93c99b2d9ab386c35916f85e0fdaf7924454fd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0669796a809dd1a15ad70d4ab6293181ca3dff4bb2b4224889aebd0d0724b4ce"
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
