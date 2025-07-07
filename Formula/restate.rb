class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "95f66eeb1707f646bf063cb5f204e11f6cc5b24373ff993d0a444c7f15e3d214"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1c019fe68cad85c26cf85afb724f5dc28138fe2d240d0aceea09c33e658da4c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "37fde26a5805dc242dea3310a45d35c7cb836a88fa217f612bdf215c42fca5b5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c4e83e05954df78692763db282e4580b31195c514033652cdc997c5e4f0ae8fa"
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
