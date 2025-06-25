class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "557bc286bb0a13d0d84d3ba2a1d66aa7794bf304afae9c3d17e17859510352fa"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "faf4af5b00d2bd15c1a37141dbd463e1b5ca017bbb9be9e8082ce00b9f8b897d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3eabc6dba515e3547d38eb65688e04f65bf11244095dc90780a9f54d8e4e30bd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "972b7a79d9ebb4a758ea02714d2fe7b41f759b0fd569e0caef5158a96f35399b"
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
