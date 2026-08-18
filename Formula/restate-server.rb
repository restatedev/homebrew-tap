class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "fbc2d01e4e471f9a6395c3302e0452477a0be654caa503350b9c52b92dec5eac"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "a7975a15cf1e22af48f5760e9ef5b096eb2b9a49d30b949641ce589aae86981a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "69a01ef2e69c596aad7cb4be690776f1cfc821a5d96174c9f77bad938ce586c7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "895ec4af4f7b297e485441d6d9c07c2e7cecdf18266bbc3a2cb77e23408be7ea"
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
      bin.install "restate-server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate-server"
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
