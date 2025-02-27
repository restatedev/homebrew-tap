class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "55c7c2b8478f907c1afa41450eac128fee658103f867ad67e9248bc6644a9ca0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "f50da87e2b1670bf58b486b66d9af656b4711cb5a6ef20bcd080cbc62cdad357"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4aa1facb514edec7c6f0adca8458e3dcd981d8b726a63a24e1400beced7be5e7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "393dd435b9e657072504a741917b5357f5fa8a07dce9548094cba0d059a778a5"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
