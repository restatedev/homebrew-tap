class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "edb2b737525ffdc5dcd2449d074215afbf0414ac7b41fffe0f0bb7878522c58c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "cfc7cd2e8670bec062bf1e771f67ee28342ebf1366e9edcaf0c07274f0997cba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5b69c7c0a6e55bb70802924ce822ea0943d82d9b6cac157f24eb85d788d35976"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c36e6609a591aaa5914dd21143249e76745704b571d4a5735c1ca6c20b13bdcf"
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
