class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "bf39d56d0bdd3bb04e20f93d88a910d189e24d838402c6be9712b1fd1116718d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "faa3469a81fd3e24c737c83eceff33f16a9c53a24e398904b0cf538f57348e06"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b8f5badfe9dfb6f780319f9a6eea2d02d50c2bda9ca666b0ac995075dce87ed5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8a60e5677f9baf388d6209e0f5839507acaef9499c7e7c779186453b1b431cff"
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
