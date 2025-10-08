class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "183c6f7719f09a639b33b535d0e1cefcda7641f81fe410bbd1918116cf478fb6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "345b0c6fd3d2a38193a5846c11875fa98bb49f518e4ad3d275a0d953b1076efc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f9a9abac8c4edf0c8b48db43407290f7bba7dcb6ceebb9ebb6079fffe4657581"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ca9cf69c6f901cf39fc100b7800fd91e2b700078661a40b6b6713cc95bab1f42"
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
