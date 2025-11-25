class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "e737fa0ef7a018447f100370e76d835916d9dba432fe624a9a7e794c866b8efe"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "a2408e781ea12889f54129720799d8c49cf6a10fefa7c9fcb3164fcb0ad3f747"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4d2eb4d4c2fdfd2a575118f1c198e692434a0b355cc446e9ff69c9fa04a2f76b"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "dca0ccd4e36a4fbd76c1e4b5e3adf579bfc4a4ad924aff4cf67ec429f477c3b4"
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
    bin.install "restatectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.mac? && Hardware::CPU.intel?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
