class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "c60196842315522522a64fae3341a1213f0fc7543e3b279c82e6b91ef89623b9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "18aec5c5f040745b69a0a9f5c731f8711a42cc1576775ed784a83f4a492a242c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "bd74e60fb8868764e72bd02ee156111cddb811263890d4fb207986a3e1a736e6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "551efa4601e38722b17634f840c52a3c8291a9295188234d8772287799d3d628"
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
