class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "25329b7e7e0a35c483caa0e7d0d49fed42d8b19891a782b8c18d58e24d3bde21"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "af3ed52b97c1dacd69a80b504b0ba17243b3d6a039fd642928481e36807069da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0c340e17f00e23aa6d3b163ae145b5223038c896c9e630fc3623d907d16f6cf7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f390e58e113627960a9c67f0cf50bfc05a61d5dcebcc286ce70ea878f32709e2"
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
