class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e8485bc3509634d304aa7bead48926e86f1eeeb1430267af3dca9c2cef0dd476"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e046243f7fe5d1e0be1ae90bbc1ac458b6fcedd898d86c4f4152c8b1498b5463"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5cda4e8187637670ec7035504fd29cc60c59f268bb47c931c739365db5279822"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "181db7815807efcfd17b568570149a347659ac75ff417b895512c7fe9c51c904"
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
