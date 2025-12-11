class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "01c7a844b6d112256d7028563bd239f55b832170b2084bfe347b87ea0454bc06"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a8d9967519917fd69a7eb4d7d1a7649ea2b108039caa57722636f114e5dd90de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f5b1f9fe9f74834b7583299207f4be7ce081dab04a2e4cdf2194af2a6229a47f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.6/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a1d4d60d293428fc4649e1b6fcbf320e83591b26828c2d7e68e06af148d4500a"
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
