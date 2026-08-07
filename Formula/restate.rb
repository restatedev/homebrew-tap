class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6708f11ad60bbb7af5af5fd1f0709a96f70318ae91a3c3ebcaefe6e06ad576a4"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c0dc4c2283664f061bd8ff3dbe974b55f522e16a9ff147dd46282b8e96fcb17b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cee45a4e81a8d276b13475f6377250e72c9c6dd3ff6edc95f2fe24775f7a9f6b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5329fca65e1439186b94d796f2d75eeb5dcdd97fe5865cbdb8d0a942519cae09"
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
